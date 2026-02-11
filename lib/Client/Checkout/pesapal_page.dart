import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
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
    required this.productDescription,
    required this.totalAmount,
    required this.orderDestination,
  });

  final int totalAmount;
  final String phoneNumber;
  final String email;
  final String firstName;
  final String productDescription;
  final String orderDestination;

  @override
  State<PesapalPage> createState() => _PesapalPageState();
}

class _PesapalPageState extends State<PesapalPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final Orders _order = Orders();
  late final WebViewController _webViewController;

  String? confirmationCode,
      payingNumber,
      methodOfPayment,
      dateCreated,
      paymentStatus;
  String? checkoutUrl;
  String? trackingId;
  String? userId;
  bool isLoading = false;
  final String callbackUrl = "https://mealmind-eight.vercel.app";
  final String paymentEndpoint =
      "https://fastapi-pesapal.onrender.com/payments/initiate";
  final String statusEndpoint =
      "https://fastapi-pesapal.onrender.com/payments/status";

  @override
  void initState() {
    super.initState();
    initiatePayment();
    if (kIsWeb) {
      return;
    }
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) async {
          if (request.url.contains(callbackUrl)) {
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
        "customer_last_name": "",
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
        if (checkoutUrl != null && !kIsWeb) {
          _webViewController.loadRequest(Uri.parse(checkoutUrl!));
        }
      }
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Error : $error", toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> checkPaymentStatus({required String trackId}) async {
    try {
      if (userId == null) {
        Fluttertoast.showToast(
            msg: "User Id is empty", toastLength: Toast.LENGTH_SHORT);
        return;
      }
      if (trackId.isEmpty) {
        Fluttertoast.showToast(
            msg: "Invalid Tracking Id", toastLength: Toast.LENGTH_SHORT);
        return;
      }
      final response = await http.post(Uri.parse(statusEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'order_tracking_id': trackId,
          }));
      if (response.statusCode == 200) {
        final data = response.body;
        final responseData = jsonDecode(data);
        confirmationCode = responseData['confirmation_code'];
        payingNumber = responseData['payment_account'];
        methodOfPayment = responseData['payment_method'];
        dateCreated = responseData['created_date'];
        paymentStatus = responseData['payment_status_description'];
      }
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Error checking payment status",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  //add order to db
  Future<void> addOrder() async {
    try {
      await checkPaymentStatus(trackId: trackingId!);

      if (userId == null) {
        Fluttertoast.showToast(
            msg: "User Id is empty", toastLength: Toast.LENGTH_SHORT);
        return;
      }
      await _order.addOrder(OrderModel(
        orderDestination: widget.orderDestination,
        orderDescription: widget.productDescription,
        totalAmount: widget.totalAmount,
        phoneNumber: payingNumber!,
        methodOfPayment: methodOfPayment!,
        confirmationNumber: confirmationCode!,
        paymentStatus: paymentStatus!,
        dateCreated: dateCreated!,
      ));
      if (paymentStatus!.toLowerCase() == "Success") {
        Fluttertoast.showToast(
            msg: "Payment Successful", toastLength: Toast.LENGTH_SHORT);
      } else {
        Fluttertoast.showToast(
            msg: "Payment Failed", toastLength: Toast.LENGTH_SHORT);
      }
      if (kIsWeb) {
        Navigator.popUntil(context, ModalRoute.withName('/tabs'));
      }
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Error adding order: $error", toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> loadOnWeb() async {
    if (checkoutUrl != null) {
      await UrlLauncher.launchUrl(Uri.parse(checkoutUrl!),
          webOnlyWindowName: '_self');
    } else {
      initiatePayment();
      await UrlLauncher.launchUrl(
        Uri.parse(checkoutUrl!),
        webOnlyWindowName: '_self',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    userId = Provider.of<Logins>(context).userId;

    return Scaffold(
        backgroundColor: Colors.grey[600],
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Choose your Payment Method'),
          centerTitle: true,
        ),
        body: kIsWeb
            ? Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          loadOnWeb();
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: const Text('Proceed to Payment'),
                      ),
              )
            : WebViewWidget(controller: _webViewController));
  }
}
