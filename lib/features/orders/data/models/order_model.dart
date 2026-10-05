import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_item_entity.dart';
import '../../domain/enums/order_status.dart';
import '../../domain/enums/payment_status.dart';
import '../../../addresses/domain/entities/address_entity.dart';
import '../../../addresses/data/models/address_model.dart';
import '../../../delivery/domain/entities/delivery_slot_entity.dart';
import '../../../delivery/data/models/delivery_slot_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.subtotal,
    required super.discount,
    required super.deliveryFee,
    required super.tip,
    required super.tax,
    required super.total,
    required super.currency,
    required super.shippingAddress,
    required super.deliverySlot,
    required super.status,
    required super.paymentStatus,
    super.paymentMethod,
    super.paymentTransactionId,
    required super.coldChainConfirmed,
    required super.temperatureIntegrityConfirmed,
    super.specialInstructions,
    super.cancellationReason,
    super.couponCode,
    super.estimatedDeliveryAt,
    super.deliveredAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      userId: entity.userId,
      items: entity.items,
      subtotal: entity.subtotal,
      discount: entity.discount,
      deliveryFee: entity.deliveryFee,
      tip: entity.tip,
      tax: entity.tax,
      total: entity.total,
      currency: entity.currency,
      shippingAddress: entity.shippingAddress,
      deliverySlot: entity.deliverySlot,
      status: entity.status,
      paymentStatus: entity.paymentStatus,
      paymentMethod: entity.paymentMethod,
      paymentTransactionId: entity.paymentTransactionId,
      coldChainConfirmed: entity.coldChainConfirmed,
      temperatureIntegrityConfirmed: entity.temperatureIntegrityConfirmed,
      specialInstructions: entity.specialInstructions,
      cancellationReason: entity.cancellationReason,
      couponCode: entity.couponCode,
      estimatedDeliveryAt: entity.estimatedDeliveryAt,
      deliveredAt: entity.deliveredAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items.map((e) => {
        'productId': e.productId,
        'variantId': e.variantId,
        'productName': e.productName,
        'variantName': e.variantName,
        'quantity': e.quantity,
        'unitPrice': e.unitPrice,
        'totalPrice': e.totalPrice,
        'imageUrl': e.imageUrl,
        'coldChainRequired': e.coldChainRequired,
        'requiresDryIce': e.requiresDryIce,
      }).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'deliveryFee': deliveryFee,
      'tip': tip,
      'tax': tax,
      'total': total,
      'currency': currency,
      'addressId': shippingAddress.id,
      'deliverySlotId': deliverySlot.id,
      'status': status.name,
      'paymentStatus': paymentStatus.name,
      'paymentMethod': paymentMethod,
      'paymentTransactionId': paymentTransactionId,
      'coldChainConfirmed': coldChainConfirmed,
      'temperatureIntegrityConfirmed': temperatureIntegrityConfirmed,
      'specialInstructions': specialInstructions,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  OrderModel copyWithId(String newId) {
    return OrderModel(
      id: newId,
      userId: userId,
      items: items,
      subtotal: subtotal,
      discount: discount,
      deliveryFee: deliveryFee,
      tip: tip,
      tax: tax,
      total: total,
      currency: currency,
      shippingAddress: shippingAddress,
      deliverySlot: deliverySlot,
      status: status,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      paymentTransactionId: paymentTransactionId,
      coldChainConfirmed: coldChainConfirmed,
      temperatureIntegrityConfirmed: temperatureIntegrityConfirmed,
      specialInstructions: specialInstructions,
      cancellationReason: cancellationReason,
      couponCode: couponCode,
      estimatedDeliveryAt: estimatedDeliveryAt,
      deliveredAt: deliveredAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  OrderEntity toEntity() => this;
}

