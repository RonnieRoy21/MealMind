import 'package:flutter/material.dart';
import '../../Database/orders.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late final Orders _myOrders = Orders();
  List _orders = [];
  bool fetchCompleted = true;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      body: FutureBuilder(
          future: (fetchCompleted)
              ? _myOrders.getMyCompletedOrders()
              : _myOrders.getAllMyOrders(),
          builder: (context, snapshot) {
            try {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                  semanticsLabel: 'Loading ...',
                ));
              } else if (snapshot.hasError) {
                return Center(child: Text('SnapshotError: ${snapshot.error}'));
              } else if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return Center(child: Text('No Orders found'));
              } else if (snapshot.hasData) {
                _orders = snapshot.data!;
              } else {
                Center(child: Text('No Orders'));
              }
            } catch (error) {
              Center(child: Text("Error: $error"));
            }
            return ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ExpansionTile(
                            backgroundColor: Colors.grey[300],
                            title: Text(
                                'Order_Description: ${order.orderDescription}'),
                            subtitle:
                                Text('Total Paid : Ksh ${order.totalAmount}'),
                            trailing: Text(order.orderDestination
                                .toString()
                                .toUpperCase()),
                            children: [
                              ListTile(
                                title: Text(
                                    'Status: ${order.paymentStatus.toString().toUpperCase()}'),
                                subtitle: Text(
                                    'Payment Method: ${order.methodOfPayment}'),
                                trailing: Text('Paid By ${order.phoneNumber}'),
                              ),
                              ListTile(
                                title: Text(
                                    'Confirmation Number: ${order.confirmationNumber}'),
                                trailing: Text('''
                    Date: ${order.dateCreated.toString().split('T')[0]}
                    Time: ${order.dateCreated.toString().split('T')[1].split('.')[0]}
                    '''),
                              )
                            ]),
                        Divider(
                            color: Colors.purpleAccent,
                            thickness: 1.0,
                            height: 1.0),
                      ]);
                });
          }),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purpleAccent,
        currentIndex: fetchCompleted ? 1 : 0,
        type: BottomNavigationBarType.fixed,
        onTap: (value) => setState(() {
          fetchCompleted = value == 1;
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inclusive),
            label: 'All Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Paid Orders',
          ),
        ],
      ),
    );
  }
}
