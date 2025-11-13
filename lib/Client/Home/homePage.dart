import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataModels/BasketModel.dart';
import '../../DataModels/Basket_Item.dart';
import '../../DataModels/meal_model.dart';
import '../../Database/orders.dart';
import '../../Database/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Logins logins = Logins();
  late final Orders getMeals = Orders();


  List<Meals> meals = [];


  @override
  Widget build(BuildContext context) {
    final basket =Provider.of<BasketModel>(context);
    final Uid=Provider.of<Logins>(context).userId;
    print('user id in home page is : $Uid');
    return Scaffold(
        appBar: AppBar(
            leading: Icon(Icons.home),
            title: Text('Home'),
            centerTitle: true,
            backgroundColor: Colors.purpleAccent,
            actions: [
              TextButton(
                onPressed: () async {
                  final response = await logins.logout();
                  if (response == "Success") {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Logged Out"),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ));
                    Navigator.pushReplacementNamed(context, '/login');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(response),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2)));
                  }
                },
                child: Text('Logout'),
              )
            ]),
        body: FutureBuilder(
          future:getMeals.fetchMeals(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(
                color: Colors.purpleAccent,
                strokeWidth: 5,
                backgroundColor: Colors.white,
                semanticsLabel: 'Loading',
              ));
            }
            if(snapshot.hasError){
              return Center(child: Text('Error : ${snapshot.error}'));
            }
            meals=snapshot.data!;
            return ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal= meals[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                          imageUrl: meal.mealImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                      ListTile(
                        onTap: (){
                          Navigator.pushNamed(context, '/preview_meal',arguments: {
                            'image': meal.mealImage,
                            'title': meal.mealName,
                            'price': meal.mealPrice,
                            'description': meal.mealDescription,
                          });},
                        title: Text('${meal.mealName}'),
                        subtitle: Text('Price: ${meal.mealPrice}'),
                        trailing: IconButton.outlined(onPressed: (){
                          try{
                            if(!basket.containsItem(meal.mealName!)){
                              basket.addToBasket(BasketItem(
                                  name: meal.mealName!,
                                  image: meal.mealImage!,
                                  price: meal.mealPrice!));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Added to basket'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                                dismissDirection: DismissDirection.horizontal,
                              ));
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Already in basket'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                                dismissDirection: DismissDirection.horizontal,
                              ));
                            }
                          }catch(e){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(e.toString().toUpperCase()),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ));
                          }
                        }, icon: Icon(Icons.add_shopping_cart)),
                      ),
                      Divider(),
                      TextButton(onPressed: (){
                        print(meal.mealName);//this gives the separated version of query
                        Navigator.pushNamed(context, '/analysis',arguments: {
                          'food': meal.mealName,
                          'grams': 100,
                        });
                      }, child: Text('View Standard Nutrition')),
                    ],
                  ),
                );
              },
            );
          }
        )

    );
  }
}
