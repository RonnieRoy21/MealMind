import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Account.dart';

class PaySection extends StatefulWidget {
  const PaySection({super.key});

  @override
  State<StatefulWidget> createState() => _PaySectionState();
}

class _PaySectionState extends State<PaySection> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final foodName = args['foodName'];
    final priceToPay = args['priceToPay'];

    SupabaseClient supabase = Supabase.instance.client;

    TextEditingController amountGiven = TextEditingController();

    Account myAccount = Account();

    int amount = int.parse(priceToPay);

    return Scaffold(
        backgroundColor: Colors.yellowAccent,
        appBar: AppBar(
          backgroundColor: Colors.blue[600],
          title: Text('Pay for Your Food Here'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Card(
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Your ordered : $foodName"),
                  Text("Total Price is :$priceToPay "),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.yellow),
                          ),
                          onPressed: () async {
                            try {
                              var result = await myAccount.payFood(amount);
                              if (result == true) {
                                await supabase.from('Orders').insert({
                                  'food_name': foodName,
                                  'food_price': amount
                                });
                                Fluttertoast.showToast(
                                    msg: "Receipt Saved ",
                                    toastLength: Toast.LENGTH_LONG);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Receipt Not Saved");
                              }
                            } catch (e) {
                              Fluttertoast.showToast(
                                  msg: "ERROR : ${e.toString()}");
                            }
                          },
                          child: Text("Pay")),
                      TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/menu');
                          },
                          child: Text("Cancel Purchase"))
                    ],
                  ),
                  SizedBox(height: 15.0),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Card(
                margin: EdgeInsets.all(20.0),
                color: Colors.cyan[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Low Balance?..We Got You...Deposit Money below'),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        Text('Enter Amount To Deposit ==> '),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: amountGiven,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    ElevatedButton(
                        onPressed: () {
                          String amountDeposit = amountGiven.text.trim();
                          int depositAmount = int.tryParse(amountDeposit) ?? 0;
                          myAccount.depositMoney(depositAmount);
                        },
                        child: Text('Deposit')),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
