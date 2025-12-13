import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../DataModels/order_model.dart';
import '../../Database/login.dart';
import '../../Database/orders.dart';

class PesapalPage extends StatefulWidget {
  const PesapalPage({
    super.key,
    required this.phoneNumber,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.productDescription,
    required this.totalAmount,
  });

  final int totalAmount;
  final String phoneNumber;
  final String email;
  final String firstName;
  final String lastName;
  final String productDescription;

  @override
  State<PesapalPage> createState() => _PesapalPageState();
}

class _PesapalPageState extends State<PesapalPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final Orders _order = Orders();
  late final WebViewController _webViewController;

  String? confirmationCode, payingNumber, methodOfPayment,dateCreated,paymentStatus;
  String? checkoutUrl;
  String? trackingId;
  String? userId;
  final String callbackUrl = "https://www.google.com";
  final String paymentEndpoint = "https://fastapi-pesapal.onrender.com/payments/initiate";
  final String statusEndpoint ="https://fastapi-pesapal.onrender.com/payments/status";

  @override
  void initState() {

    super.initState();
     initiatePayment();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) async{
          if (request.url.contains(callbackUrl)){
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/tabs');
             await addOrder();
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ));
  }

  Future<void> initiatePayment() async {
    try {
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();

      final paymentData = {
        "order_id": orderId,
        "amount": widget.totalAmount,
        "currency": "KES",
        "description": widget.productDescription,
        "customer_email": widget.email,
        "customer_phone": widget.phoneNumber,
        "customer_first_name": widget.firstName,
        "customer_last_name": widget.lastName,
        "callback_url": callbackUrl,
      };

      final response = await http.post(
        Uri.parse(paymentEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(paymentData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        checkoutUrl = responseData['redirect_url'];
        trackingId = responseData['order_tracking_id'] ??
            responseData['OrderTrackingId'];
        if (checkoutUrl != null) {
          _webViewController.loadRequest(Uri.parse(checkoutUrl!));
        } else {
          Fluttertoast.showToast(msg: "Invalid Check-Out Url",toastLength: Toast.LENGTH_SHORT);
        }
      } else {
       Fluttertoast.showToast(msg: "Payment initiation failed",toastLength: Toast.LENGTH_SHORT);
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error initiating Payment",toastLength: Toast.LENGTH_SHORT);
    }
  }

  Future<void> checkPaymentStatus({required String trackId}) async {
    try {
      if (userId==null){
        Fluttertoast.showToast(msg: "User Id is empty",toastLength: Toast.LENGTH_SHORT);
        return;
      }
      if(trackId.isEmpty){
        Fluttertoast.showToast(msg: "Invalid Tracking Id",toastLength: Toast.LENGTH_SHORT);
        return;
      }
       final response= await http.post(
        Uri.parse(statusEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'order_tracking_id': trackId,
          })
      );
       if(response.statusCode==200){
         final data=response.body;
         final responseData=jsonDecode(data);
         confirmationCode=responseData['confirmation_code'];
         payingNumber=responseData['payment_account'];
         methodOfPayment=responseData['payment_method'];
         dateCreated=responseData['created_date'];
         paymentStatus=responseData['payment_status_description'];
       }
    }catch(error){
      Fluttertoast.showToast(msg: "Error checking payment status",toastLength: Toast.LENGTH_SHORT);
    }
  }

  //add order to db
  Future<void> addOrder() async {

    try {
      await checkPaymentStatus(trackId: trackingId!);

      if (userId==null){
        Fluttertoast.showToast(msg: "User Id is empty",toastLength: Toast.LENGTH_SHORT);
        return;
      }
     await _order.addOrder(OrderModel(
        orderDescription: widget.productDescription,
        totalAmount: widget.totalAmount,
        phoneNumber: payingNumber!,
        methodOfPayment: methodOfPayment!,
        confirmationNumber: confirmationCode!,
        paymentStatus: paymentStatus!,
        dateCreated: dateCreated!,
      ));
      (paymentStatus == 'Success' )? Fluttertoast.showToast(msg: "Order added successfully",toastLength: Toast.LENGTH_SHORT) : Fluttertoast.showToast(msg: "Order not paid",toastLength: Toast.LENGTH_SHORT);
    }catch(error){
      Fluttertoast.showToast(msg: "Error adding order: $error",toastLength: Toast.LENGTH_LONG);
    }
  }
  @override
  Widget build(BuildContext context) {
    userId=Provider.of<Logins>(context).userId;
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Choose your Payment Method'),
        centerTitle: true,
      ),
      body:WebViewWidget(controller: _webViewController)
    );
  }
}



