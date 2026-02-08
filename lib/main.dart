import 'package:flutter/material.dart';
import 'package:flutter1/Admin/AddMeal/add_meal.dart';
import 'package:flutter1/Admin/DeleteMeal/delete_meal.dart';
import 'package:flutter1/Admin/EditMeal/edit_meal.dart';
import 'package:flutter1/Admin/customer_ratings/customer_ratings.dart';
import 'package:flutter1/Client/Home/home_page.dart';
import 'package:flutter1/Client/Login/login_page.dart';
import 'package:flutter1/Client/Login/new_account.dart';
import 'package:flutter1/Client/Orders/orders_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Client/Basket/basket.dart';
import 'Client/Home/preview_meal.dart';
import 'Client/Login/profile_page.dart';
import 'DataModels/basket_model.dart';
import 'Database/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ckfmwciphvndwokavthy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNrZm13Y2lwaHZuZHdva2F2dGh5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcxNTE5OTAsImV4cCI6MjA3MjcyNzk5MH0.lck0WSNLhiuJpb9ssaO6rROCfQHMI4jECxfT05kSpZ0', // Replace with your Supabase anon key
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BasketModel()),
        ChangeNotifierProvider(create: (_) => Logins()), // Your second provider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: Login(),
        routes: {
          '/tabs': (context) => Tabs(),
          '/login': (context) => Login(),
          '/home': (context) => HomePage(),
          '/new_account': (context) => NewAccount(),
          '/preview_meal': (context) => PreviewMeal(),
          '/edit_meal': (context) => EditMeal(),
          '/basket': (context) => Basket(),
          '/orders': (context) => OrdersPage(),
          '/profile': (context) => ProfilePage(),
        },
      ),
    ),
  );
}

class Tabs extends StatefulWidget {
  final String? userRole;
  const Tabs({super.key, this.userRole});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;

  late final List<Widget> _pagesClient = [
    HomePage(
      role: widget.userRole,
    ),
    Basket(),
    OrdersPage(),
    ProfilePage(),
  ];
  late final List<Widget> _pagesAdmin = [
    HomePage(
      role: widget.userRole,
    ),
    AddMeal(),
    OrdersPage(),
    DeleteMeal(),
    CustomerRatings(),
    ProfilePage(),
  ];

  final List<BottomNavigationBarItem> _itemsAdmin = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Meal'),
    BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Orders'),
    BottomNavigationBarItem(icon: Icon(Icons.delete), label: 'Delete Meal'),
    BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Customer Ratings'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];
  final List<BottomNavigationBarItem> _itemsClient = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: 'Basket'),
    BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Orders'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.userRole.toString().isEmpty)
        ? Center(
            child: CircularProgressIndicator(
            color: Colors.purpleAccent,
            semanticsLabel: 'Fetching user role...',
          ))
        : Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.purpleAccent,
              unselectedItemColor: Colors.lightBlue,
              showUnselectedLabels: true,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: (widget.userRole == 'admin') ? _itemsAdmin : _itemsClient,
            ),
            body: ((widget.userRole == 'admin')
                ? _pagesAdmin[_currentIndex]
                : _pagesClient[_currentIndex]));
  }
}
