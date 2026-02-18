import 'package:flutter/material.dart';

import '../../Database/login.dart';

class NewAccount extends StatefulWidget {
  const NewAccount({super.key});

  @override
  State<NewAccount> createState() {
    return _NewAccountState();
  }
}

class _NewAccountState extends State<NewAccount> {
  final _formKey = GlobalKey<FormState>();
  final Logins logins = Logins();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _psswdObscureText = true;
  bool _confirmPsswdObscureText = true;

  // Track checked conditions
  final Map<String, bool> _selectedConditions = {};

  final List<String> _healthConditions = [
    "Diabetes",
    "Hypertension",
    "Heart Disease",
    "None",
  ];

  @override
  void initState() {
    super.initState();
    // initialize all conditions as unchecked
    for (var condition in _healthConditions) {
      _selectedConditions[condition] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: [AutofillHints.email],
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter an email";
                      }
                      return null;
                    }),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _psswdObscureText,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _psswdObscureText = !_psswdObscureText;
                          });
                        },
                        icon: _psswdObscureText
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility)),
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a password";
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _confirmPsswdObscureText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _confirmPsswdObscureText =
                                  !_confirmPsswdObscureText;
                            });
                          },
                          icon: _confirmPsswdObscureText
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility)),
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please confirm your password";
                      }
                      return null;
                    }),
              ),

              const SizedBox(height: 10),

              //  Health Conditions
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _healthConditions.length,
                itemBuilder: (context, index) {
                  final condition = _healthConditions[index];
                  return CheckboxListTile(
                    title: Text(condition),
                    value: _selectedConditions[condition],
                    checkColor: Colors.white,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        if (condition == "None" && value == true) {
                          // Uncheck all others if "None" is selected
                          _selectedConditions.updateAll((key, val) => false);
                          _selectedConditions["None"] = true;
                        } else {
                          // Normal condition toggled
                          _selectedConditions[condition] = value!;

                          if (value == true) {
                            _selectedConditions["None"] =
                                false; // uncheck None if another is selected
                          } else {
                            // Prevent all from being unchecked
                            if (!_selectedConditions.containsValue(true)) {
                              _selectedConditions[condition] =
                                  true; // re-check it
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("select at least one condition"),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        }
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(Size(100, 50)),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        backgroundColor: WidgetStateProperty.all(Colors.blue),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final conditions = getSelectedConditions();

                          if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Passwords don't match"),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }
                          if (conditions.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("select at least one condition"),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2)));
                            return;
                          }

                          try {
                            // Sign up and immediately insert profile
                            final response = await logins.registerWithEmail(
                              email: _emailController.text,
                              password: _passwordController.text,
                              conditions: conditions,
                            );
                            if (response == "Success") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Account Created"),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              Navigator.pushReplacementNamed(context, '/login');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 4),
                              ),
                            );
                          }
                        }
                      },
                      child: Text('Create Account'),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // helper to get selected
  List<String> getSelectedConditions() {
    return _selectedConditions.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();
  }
}
