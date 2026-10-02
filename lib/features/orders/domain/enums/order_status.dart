enum OrderStatus {
  pending,
  confirmed,
  preparing,
  packed,
  outForDelivery,
  delivered,
  cancelled,
  failed;

  bool get isTerminal =>
      this == OrderStatus.delivered ||
      this == OrderStatus.cancelled ||
      this == OrderStatus.failed;

  bool canTransitionTo(OrderStatus next) {
    const transitions = {
      OrderStatus.pending: [OrderStatus.confirmed, OrderStatus.cancelled, OrderStatus.failed],
      OrderStatus.confirmed: [OrderStatus.preparing, OrderStatus.cancelled],
      OrderStatus.preparing: [OrderStatus.packed, OrderStatus.cancelled],
      OrderStatus.packed: [OrderStatus.outForDelivery],
      OrderStatus.outForDelivery: [OrderStatus.delivered, OrderStatus.failed],
      OrderStatus.delivered: <OrderStatus>[],
      OrderStatus.cancelled: <OrderStatus>[],
      OrderStatus.failed: <OrderStatus>[],
    };
    return transitions[this]?.contains(next) ?? false;
  }
}
