import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/Client/Checkout/pesapal_page.dart';
import 'package:provider/provider.dart';
import '../../DataModels/basket_model.dart';

class Basket extends StatefulWidget {
  const Basket({super.key});

  @override
  State<Basket> createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();

  final formKey =GlobalKey<FormState>();

  final Map<int, bool> checkedStates = {};
  final Map<int, TextEditingController> quantityControllers = {};
  int totalPrice = 0;

  void calculateTotals(List items) {
    int total = 0;
    for (int i = 0; i < items.length; i++) {
      if (checkedStates[i] == true) {
        int qty = int.tryParse(quantityControllers[i]?.text ?? "1") ?? 1;
        int price = int.tryParse(items[i].price.toString()) ?? 0;
        total += price * qty;
      }
    }
    setState(() {
      totalPrice = total;
    });
  }

  @override
  Widget build(BuildContext context) {

    final basket = Provider.of<BasketModel>(context);
    final basketIsEmpty = basket.items.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basket'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      body: basketIsEmpty
          ? const Center(child: Text("Basket is empty"))
          : ListView.builder(
        itemCount: basket.items.length,
        itemBuilder: (context, index) {
          final item = basket.items[index];
          quantityControllers[index] ??= TextEditingController(text: "1");
          checkedStates[index] = checkedStates[index] ?? false;

          return Column(
            children: [
              Container(
                color: checkedStates[index] == true
                    ? Colors.purple.shade50
                    : Colors.transparent,
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: item.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item.name),
                  subtitle: Text("${item.price} Ksh each"),
                  trailing: Checkbox(
                    activeColor: Colors.purple,
                    value: checkedStates[index],
                    onChanged: (value) {
                      setState(() {
                        checkedStates[index] = value ?? false;
                      });
                      calculateTotals(basket.items);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 4),
                child: TextFormField(
                  controller: quantityControllers[index],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Quantity",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => calculateTotals(basket.items),
                ),
              ),
              const Divider(thickness: 1, color: Colors.purple),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            Text(
              "Total: ${totalPrice.toStringAsFixed(2)} Ksh",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed:!(totalPrice > 0) ? null : () {
                showModalBottomSheet(context: context,
                    builder: (context){
                  return SingleChildScrollView(
                    child: Form(
                        canPop: true,
                        key: formKey,
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              TextFormField(
                                validator: (value){
                                  if(value!.isEmpty){
                                    return "Please enter your phone number";
                                  }
                                  return null;
                                },
                                controller: _phoneController ,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Phone Number",
                                  hintText: "The One To Pay With",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height:8),
                              TextFormField(
                                validator: (value){
                                  if(value!.isEmpty){
                                    return "Please enter your email";
                                  }
                                  return null;
                                },
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                  border: OutlineInputBorder(),
                                ),),
                              const SizedBox(height:8),
                              TextFormField(
                                validator: (value){
                                  if(value!.isEmpty){
                                    return "Please enter your first name";
                                  }
                                  return null;
                                },
                                controller: _firstNameController,
                                decoration: const InputDecoration(
                                  labelText: "First Name",
                                  border: OutlineInputBorder(),
                                ),),
                              const SizedBox(height:8),
                              TextFormField(
                                validator: (value){
                                  if(value!.isEmpty){
                                    return "Please enter your last name";
                                  }
                                  return null;
                                },
                                controller: _lastNameController,
                                decoration: const InputDecoration(
                                  labelText: "Last Name",
                                  border: OutlineInputBorder(),
                                ),),
                              const SizedBox(height:8),
                              TextFormField(
                                validator: (value){
                                  if(value!.isEmpty){
                                    return "Please enter your product description";
                                  }
                                  return null;
                                },
                                controller: _productDescriptionController,
                                decoration: const InputDecoration(
                                  labelText: "Give your Order a Description",
                                  border: OutlineInputBorder(),
                                ),),
                              const SizedBox(height:8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                                onPressed: () {
                                  try {
                                    if (formKey.currentState!.validate()) {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) =>
                                              PesapalPage(
                                                  phoneNumber: _phoneController
                                                      .text,
                                                  email: _emailController.text,
                                                  firstName: _firstNameController
                                                      .text,
                                                  lastName: _lastNameController
                                                      .text,
                                                  productDescription: _productDescriptionController
                                                      .text,
                                                  totalAmount: totalPrice
                                              )
                                          )
                                      );
                                    } else {
                    
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Form is not valid"),
                                        ),
                                      );
                                    }
                                  }catch(e){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Error Occurred :${e.toString()}"),
                                      ),
                                    );
                                  }
                                },
                                child: const Text("Checkout",style: TextStyle(color: Colors.white,fontSize: 16),),
                              ),
                            ]
                        )
                      ),
                  );
                }
                  );
                    },
              child: const Text(
                "Proceed",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
