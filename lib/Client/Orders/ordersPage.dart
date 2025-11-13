import 'package:flutter/material.dart';
import 'package:flutter1/Database/login.dart';
import 'package:provider/provider.dart';

import '../../Database/orders.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});


  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late final Orders _myOrders= Orders();
  List _orders = [];


  @override
  Widget build(BuildContext context) {
    final userId=Provider.of<Logins>(context).userId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      body: FutureBuilder(future:_myOrders.getMyOrders(userId!) ,
          builder: (context,snapshot){
        try{
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(semanticsLabel: 'Loading ...',));
        }else if(snapshot.hasError){
          return Center(child: Text('SnapshotError: ${snapshot.error}'));
        }else if(snapshot.hasData){
          _orders = snapshot.data!;
          }else{
          Center(child: Text('No Orders'));
        }
        }catch(error){
          Center(child: Text("Error: $error"));
        }
        return ListView.builder(
          itemCount: _orders.length,
            itemBuilder:(context,index){
              final order = _orders[index];
              return ExpansionTile(
                backgroundColor: Colors.green[300],
                title: Text('Description: ${order.orderDescription}'),
                subtitle: Text('Total : ${order.totalAmount}'),
                children: [
                  ListTile(

                    title: Text('Status: ${order.paymentStatus.toString().toUpperCase()}'),
                    subtitle: Text('Payment Method: ${order.methodOfPayment}'),
                    trailing: Text('Paid By ${order.phoneNumber}'),
                  ),
                  ListTile(
                    title: Text('Confirmation Number: ${order.confirmationNumber}'),
                    trailing: Text('''
                    Date: ${order.dateCreated.toString().split('T')[0] }
                    Time: ${order.dateCreated.toString().split('T')[1].split('.')[0]}
                    '''),
                  )
                ]
              );
            }
        );
      }
      ),

    );
  }
}
