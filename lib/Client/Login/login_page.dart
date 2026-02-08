import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter1/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Database/login.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Logins logins = Logins();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late bool _obscureText = true;

  Widget webLoginPage(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      CachedNetworkImage(
          filterQuality: FilterQuality.high,
          fit: BoxFit.contain,
          height: 1000,
          width: 600,
          imageUrl:
              'https://funcheaporfree.com/wp-content/uploads/2020/09/Meal-Planning-Apps-Favoreats.jpg'),
      const SizedBox(width: 15),
      Flexible(
          child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                    autofillHints: const [AutofillHints.email],
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter an email";
                      }
                      return null;
                    }),
                const SizedBox(height: 20),
                TextFormField(
                    autofillHints: const [
                      AutofillHints.password,
                      AutofillHints.newPassword
                    ],
                    textInputAction: TextInputAction.done,
                    obscureText: _obscureText,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            }),
                        border: OutlineInputBorder(),
                        labelText: "Password"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a password";
                      }
                      return null;
                    }),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.purpleAccent),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String response = await logins.loginWithEmail(
                                _emailController.text,
                                _passwordController.text);
                            if (response == "Success") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Login Successful"),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  dismissDirection: DismissDirection.horizontal,
                                ),
                              );
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Tabs(userRole: logins.role)));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Login Failed'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  dismissDirection: DismissDirection.horizontal,
                                ),
                              );
                            }
                          }
                        },
                        child: Text('Login'),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/new_account');
                  },
                  child: Text('New Account'),
                )
              ]),
        ),
      )),
    ]);
  }

  Widget mobileLoginPage(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: CachedNetworkImage(
                  imageUrl:
                      'https://funcheaporfree.com/wp-content/uploads/2020/09/Meal-Planning-Apps-Favoreats.jpg'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter an email";
                  }
                  return null;
                }),
            const SizedBox(height: 20),
            TextFormField(
                autofillHints: const [
                  AutofillHints.password,
                  AutofillHints.newPassword
                ],
                textInputAction: TextInputAction.done,
                obscureText: _obscureText,
                controller: _passwordController,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(_obscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        }),
                    border: OutlineInputBorder(),
                    labelText: "Password"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a password";
                  }
                  return null;
                }),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      backgroundColor:
                          WidgetStateProperty.all(Colors.purpleAccent),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String response = await logins.loginWithEmail(
                            _emailController.text, _passwordController.text);
                        if (response == "Success") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Login Successful"),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              dismissDirection: DismissDirection.horizontal,
                            ),
                          );
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Tabs(userRole: logins.role)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Login Failed'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              dismissDirection: DismissDirection.horizontal,
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Login'),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/new_account');
              },
              child: Text('New Account'),
            )
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome To MealMind'),
          centerTitle: true,
          backgroundColor: Colors.purpleAccent,
        ),
        body: kIsWeb ? webLoginPage(context) : mobileLoginPage(context));
  }
}
