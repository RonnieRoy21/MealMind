import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter1/menu.dart';
import 'package:flutter1/paysection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'createUser.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://gcuqpnrtpxjritpzvnlw.supabase.co",
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdjdXFwbnJ0cHhqcml0cHp2bmx3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMyNTE0NDQsImV4cCI6MjA1ODgyNzQ0NH0.qZo6U5uNN_1c1rG-yGV1jg4yHvR3Otlx6v5EPaMu2kE');
  runApp(MaterialApp(initialRoute: '/login', home: Home(), routes: {
    '/login': (context) => Home(),
    '/createUser': (context) => CreateUser(),
    '/menu': (context) => Menu(),
    '/pay': (context) => PaySection(),
  }));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Login login = Login();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: Text('Welcome to MasterChef Restaurant and Online Food Order'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Your Email',
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.cyanAccent),
              ),
              SizedBox(
                width: 30.0,
              ),
              Expanded(
                  child: TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
              )),
            ],
          ),
          Row(children: [
            Text(
              'Your Password',
              style: TextStyle(
                color: Colors.cyanAccent,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
                child: TextField(
              obscureText: true,
              controller: password,
            )),
          ]),
          SizedBox(
            height: 20.0,
          ),
          Text('Get Your favourite Meal From Where You Sit'),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: Image.network(
                      'https://img.freepik.com/free-photo/traditional-italian-food-world-tourism-day_23-2149114038.jpg')),
              Expanded(
                  child: Image.network(
                      'https://media.istockphoto.com/id/1216404187/photo/delivery-asian-man-wear-protective-mask-in-orange-uniform-and-ready-to-send-delivering-food.jpg?s=612x612&w=0&k=20&c=oD6J2b8FdduleZYnrvqEER7pyKqfoCkMOpbmuf2-M94='))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  var response =
                      await login.loginWithEmail(email.text, password.text);
                  if (response == true) {
                    Navigator.pushReplacementNamed(context, '/menu');
                  } else {
                    Fluttertoast.showToast(msg: "Login Failed");
                  }
                },
                label: Text('Login'),
                icon: Icon(Icons.login),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/createUser');
                },
                label: Text('Sign Up'),
                icon: Icon(Icons.person_add),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  SystemNavigator.pop();
                },
                label: Text('Exit'),
                icon: Icon(Icons.logout),
              ),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}
