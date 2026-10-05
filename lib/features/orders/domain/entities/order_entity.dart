import 'package:equatable/equatable.dart';
import '../enums/order_status.dart';
import '../enums/payment_status.dart';
import '../../../addresses/domain/entities/address_entity.dart';
import '../../../delivery/domain/entities/delivery_slot_entity.dart';
import 'order_item_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final List<OrderItemEntity> items;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double tip;
  final double tax;
  final double total;
  final String currency;
  final AddressEntity shippingAddress;
  final DeliverySlotEntity deliverySlot;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final String? paymentMethod;
  final String? paymentTransactionId;
  final bool coldChainConfirmed;
  final bool temperatureIntegrityConfirmed;
  final String? specialInstructions;
  final String? cancellationReason;
  final String? couponCode;
  final DateTime? estimatedDeliveryAt;
  final DateTime? deliveredAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.tip,
    required this.tax,
    required this.total,
    required this.currency,
    required this.shippingAddress,
    required this.deliverySlot,
    required this.status,
    required this.paymentStatus,
    this.paymentMethod,
    this.paymentTransactionId,
    required this.coldChainConfirmed,
    required this.temperatureIntegrityConfirmed,
    this.specialInstructions,
    this.cancellationReason,
    this.couponCode,
    this.estimatedDeliveryAt,
    this.deliveredAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isCancellable =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;

  bool get isDelivered => status == OrderStatus.delivered;

  bool get requiresColdChain =>
      items.any((item) => item.coldChainRequired);

  @override
  List<Object?> get props => [
        id, userId, items, subtotal, discount, deliveryFee, tip, tax,
        total, currency, shippingAddress, deliverySlot, status,
        paymentStatus, paymentMethod, paymentTransactionId,
        coldChainConfirmed, temperatureIntegrityConfirmed,
        specialInstructions, cancellationReason, couponCode,
        estimatedDeliveryAt, deliveredAt, createdAt, updatedAt,
      ];
}
