import * as admin from 'firebase-admin';

admin.initializeApp();

export { createOrder } from './orders/createOrder';
// Future exports: processPaymentWebhook, reserveInventory, etc.
