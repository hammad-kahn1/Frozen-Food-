import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { v4 as uuidv4 } from 'uuid';

interface CartItemRequest {
  productId: string;
  variantId: string;
  quantity: number;
  coldChainRequired: boolean;
}

interface CreateOrderRequest {
  cartItems: CartItemRequest[];
  addressId: string;
  deliverySlotId: string;
  couponCode?: string;
  tip: number;
  paymentMethod: string;
  coldChainConfirmed: boolean;
  temperatureIntegrityConfirmed: boolean;
  specialInstructions?: string;
  idempotencyKey: string;
}

export const createOrder = functions
  .runWith({ timeoutSeconds: 60, memory: '512MB' })
  .https
  .onCall(async (data: CreateOrderRequest, context) => {
    // 1. Authentication check
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
    }

    const userId = context.auth.uid;
    const db = admin.firestore();

    // 2. Idempotency check to prevent duplicate charges
    const idempotencyRef = db.collection('orderIdempotency').doc(data.idempotencyKey);
    const existingOrder = await idempotencyRef.get();
    if (existingOrder.exists) {
      return { orderId: existingOrder.data()!.orderId, isDuplicate: true };
    }

    // 3. Cold chain verification
    const requiresColdChain = data.cartItems.some(item => item.coldChainRequired);
    if (requiresColdChain && !data.coldChainConfirmed) {
      throw new functions.https.HttpsError(
        'failed-precondition',
        'Cold chain confirmation is required for frozen products.'
      );
    }

    // 4. Fetch User Address snapshot
    const addressSnap = await db
      .collection('users').doc(userId)
      .collection('addresses').doc(data.addressId).get();
    if (!addressSnap.exists) {
      throw new functions.https.HttpsError('not-found', 'Address not found.');
    }

    const slotRef = db.collection('deliverySlots').doc(data.deliverySlotId);
    let orderTotal = 0;
    const orderId = `ord_${Date.now()}_${uuidv4().substring(0, 8)}`;

    try {
      // 5. Firestore Transaction for atomic inventory and slot booking
      await db.runTransaction(async (transaction) => {
        // --- READS ---
        const slotDoc = await transaction.get(slotRef);
        if (!slotDoc.exists || !slotDoc.data()!.isActive) {
          throw new functions.https.HttpsError('not-found', 'Delivery slot not found.');
        }
        
        const slot = slotDoc.data()!;
        if (slot.remainingCapacity <= 0) {
          throw new functions.https.HttpsError('resource-exhausted', 'Delivery slot fully booked.');
        }

        if (requiresColdChain && !slot.coldChainSupported) {
          throw new functions.https.HttpsError('failed-precondition', 'Slot does not support cold-chain.');
        }

        // Server-side price calculation
        let subtotal = 0;
        const itemPrices: Record<string, number> = {};

        for (const item of data.cartItems) {
          const productDoc = await transaction.get(db.collection('products').doc(item.productId));
          if (!productDoc.exists) throw new functions.https.HttpsError('not-found', `Product missing.`);
          
          const variant = productDoc.data()!.variants?.find((v: any) => v.id === item.variantId);
          if (!variant || !variant.isAvailable) throw new functions.https.HttpsError('not-found', `Variant missing.`);

          const inventoryDoc = await transaction.get(db.collection('inventory').doc(item.variantId));
          const available = inventoryDoc.data()?.availableQuantity ?? 0;
          if (available < item.quantity) {
            throw new functions.https.HttpsError('resource-exhausted', `Insufficient stock for ${variant.name}.`);
          }

          itemPrices[item.variantId] = variant.price;
          subtotal += variant.price * item.quantity;
        }

        const taxRate = 0.17; // Should use Remote Config
        const tax = subtotal * taxRate;
        orderTotal = subtotal + tax + slot.deliveryFee + data.tip;

        // --- WRITES ---
        // Decrement slot
        transaction.update(slotRef, {
          remainingCapacity: admin.firestore.FieldValue.increment(-1),
        });

        // Reserve stock
        for (const item of data.cartItems) {
          const inventoryRef = db.collection('inventory').doc(item.variantId);
          transaction.update(inventoryRef, {
            reservedQuantity: admin.firestore.FieldValue.increment(item.quantity),
            availableQuantity: admin.firestore.FieldValue.increment(-item.quantity),
          });
        }

        // Write order
        const orderRef = db.collection('orders').doc(orderId);
        transaction.set(orderRef, {
          id: orderId,
          userId,
          items: data.cartItems.map(item => ({
            ...item,
            unitPrice: itemPrices[item.variantId],
            totalPrice: itemPrices[item.variantId] * item.quantity,
          })),
          subtotal,
          discount: 0,
          deliveryFee: slot.deliveryFee,
          tip: data.tip,
          tax,
          total: orderTotal,
          currency: 'PKR',
          shippingAddress: addressSnap.data(),
          deliverySlot: slot,
          status: 'pending',
          paymentStatus: 'pending',
          paymentMethod: data.paymentMethod,
          coldChainConfirmed: data.coldChainConfirmed,
          temperatureIntegrityConfirmed: data.temperatureIntegrityConfirmed,
          specialInstructions: data.specialInstructions ?? null,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        // Write Idempotency key
        transaction.set(idempotencyRef, { orderId, userId, createdAt: admin.firestore.FieldValue.serverTimestamp() });
      });

      return { orderId, total: orderTotal };
    } catch (error) {
      if (error instanceof functions.https.HttpsError) throw error;
      functions.logger.error('Order creation failed', { userId, error });
      throw new functions.https.HttpsError('internal', 'Order creation failed.');
    }
  });
