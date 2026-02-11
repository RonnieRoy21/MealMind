class OrderModel{
  OrderModel({
    required this.orderDescription,
    required this.totalAmount,
    required this.phoneNumber,
    required this.methodOfPayment,
    required this.confirmationNumber,
    required this.paymentStatus,
    required this.dateCreated,
    required this.orderDestination,
});

  final String orderDescription;
  final String orderDestination;
  final int totalAmount;
  final String phoneNumber;
  final String methodOfPayment;
  final String confirmationNumber;
  final String paymentStatus;
  final String dateCreated;

factory OrderModel.fromJson(Map<String, dynamic> json){
    return OrderModel(
      orderDescription: json['order_description'].toString(),
      totalAmount: json['total_price_paid'] as int,
      phoneNumber: json['paying_number'].toString(),
      methodOfPayment: json['method_of_pay'].toString(),
      confirmationNumber: json['confirmation_code'].toString(),
      paymentStatus: json['payment_status'].toString(),
      dateCreated: json['date_of_pay'].toString(),
      orderDestination: json['order_destination'].toString(),
    );
}
}