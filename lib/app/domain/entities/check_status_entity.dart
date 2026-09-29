class CheckStatusPaymentEntity {
  final String orderId;
  final int paymentStatus;
  final int status;
  final bool isPaid;

  CheckStatusPaymentEntity({
    required this.orderId,
    required this.paymentStatus,
    required this.status,
    required this.isPaid,
  });
}
