import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataModels/basket_model.dart';
import '../../DataModels/basket_item.dart';
import '../../DataModels/meal_model.dart';
import '../../Database/orders.dart';
import '../../Database/login.dart';
import '../FoodAnalysis/nutrition_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Logins logins = Logins();
  late final Orders getMeals = Orders();

  List<Meals> meals = [];

//widget for web
  Widget webHomeWidget(
    BuildContext context,
  ) {
    final basket = Provider.of<BasketModel>(context);
    final role = Provider.of<Logins>(context, listen: true).role;
    return StreamBuilder(
        stream: getMeals.fetchMeals(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.purpleAccent,
              strokeWidth: 5,
              backgroundColor: Colors.white,
              semanticsLabel: 'Loading',
            ));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error : ${snapshot.error}'));
          }
          meals = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 1.0, crossAxisSpacing: 2.0),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      margin: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          CachedNetworkImage(
                            imageUrl: meal.mealImage!,
                            fit: BoxFit.fitWidth,
                            width: double.infinity,
                            height: 200,
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/preview_meal',
                                  arguments: {
                                    'image': meal.mealImage,
                                    'title': meal.mealName,
                                    'price': meal.mealPrice,
                                    'description': meal.mealDescription,
                                  });
                            },
                            title: Text('${meal.mealName}'),
                            subtitle: Text('Price: ${meal.mealPrice}'),
                            trailing: (role == "admin")
                                ? IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/edit_meal',
                                          arguments: meal);
                                    },
                                  )
                                : IconButton.outlined(
                                    onPressed: () {
                                      try {
                                        if (!basket
                                            .containsItem(meal.mealName!)) {
                                          basket.addToBasket(BasketItem(
                                              name: meal.mealName!,
                                              image: meal.mealImage!,
                                              price: meal.mealPrice!));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('Added to basket'),
                                            backgroundColor: Colors.green,
                                            duration: Duration(seconds: 1),
                                            behavior: SnackBarBehavior.floating,
                                            dismissDirection:
                                                DismissDirection.horizontal,
                                          ));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('Already in basket'),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 1),
                                            behavior: SnackBarBehavior.floating,
                                            dismissDirection:
                                                DismissDirection.horizontal,
                                          ));
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text(e.toString().toUpperCase()),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 2),
                                        ));
                                      }
                                    },
                                    icon: Icon(Icons.add_shopping_cart)),
                          ),
                          Divider(),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => NutritionPage(
                                            meal: meal.mealName!))));
                              },
                              child: Text('View Standard Nutrition')),
                        ],
                      ),
                    ),
                  ]);
            },
          );
        });
  }

//widget for mobile
  Widget mobileHomeWidget(
    BuildContext context,
  ) {
    final basket = Provider.of<BasketModel>(context);
    final role = Provider.of<Logins>(context, listen: true).role;
    return StreamBuilder(
        stream: getMeals.fetchMeals(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.purpleAccent,
              strokeWidth: 5,
              backgroundColor: Colors.white,
              semanticsLabel: 'Loading',
            ));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error : ${snapshot.error}'));
          }
          meals = snapshot.data!;
          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
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
                      onTap: () {
                        Navigator.pushNamed(context, '/preview_meal',
                            arguments: {
                              'image': meal.mealImage,
                              'title': meal.mealName,
                              'price': meal.mealPrice,
                              'description': meal.mealDescription,
                            });
                      },
                      title: Text('${meal.mealName}'),
                      subtitle: Text('Price: Ksh ${meal.mealPrice}'),
                      trailing: (role == "admin")
                          ? IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.pushNamed(context, '/edit_meal',
                                    arguments: meal);
                              },
                            )
                          : IconButton.outlined(
                              onPressed: () {
                                try {
                                  if (!basket.containsItem(meal.mealName!)) {
                                    basket.addToBasket(BasketItem(
                                        name: meal.mealName!,
                                        image: meal.mealImage!,
                                        price: meal.mealPrice!));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Added to basket'),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                      dismissDirection:
                                          DismissDirection.horizontal,
                                    ));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Already in basket'),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                      dismissDirection:
                                          DismissDirection.horizontal,
                                    ));
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(e.toString().toUpperCase()),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  ));
                                }
                              },
                              icon: Icon(Icons.add_shopping_cart)),
                    ),
                    Divider(),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      NutritionPage(meal: meal.mealName!))));
                        },
                        child: Text('View Standard Nutrition')),
                  ],
                ),
              );
            },
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
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
        body: kIsWeb
            ? webHomeWidget(
                context,
              )
            : mobileHomeWidget(
                context,
              ));
  }
}
