class OrderModel{
  OrderModel({
    required this.uid,
    required this.orderDescription,
    required this.totalAmount,
    required this.phoneNumber,
    required this.methodOfPayment,
    required this.confirmationNumber,
    required this.paymentStatus,
    required this.dateCreated,
});

  final String uid;
  final String orderDescription;
  final int totalAmount;
  final String phoneNumber;
  final String methodOfPayment;
  final String confirmationNumber;
  final String paymentStatus;
  final String dateCreated;

factory OrderModel.fromJson(Map<String, dynamic> json){
    return OrderModel(
      uid: json['user_id'] as String,
      orderDescription: json['order_description'] as String,
      totalAmount: json['total_price_paid'] as int,
      phoneNumber: json['paying_number'] as String,
      methodOfPayment: json['method_of_pay'] as String,
      confirmationNumber: json['confirmation_code'] as String,
      paymentStatus: json['payment_status'] as String,
      dateCreated: json['date_of_pay'] as String,
    );
}
}