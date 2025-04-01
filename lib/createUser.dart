import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login.dart';
class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  Login myLogin = Login();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[600],
        appBar: AppBar(
          title: Text(' Create New Account'),
          centerTitle: true,
          backgroundColor: Colors.brown[300],
        ),
        body: Card(
          borderOnForeground: false,
          margin: EdgeInsets.fromLTRB(10, 10, 10, 100),
          child: Column(children: [
            Row(children: [
              Text('Email'),
              SizedBox(width: 15),
              Expanded(child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: email,
              )),
            ]),
            Row(
              children: [
                Text('Password'),
                SizedBox(width: 15),
                Expanded(child: TextField(
                  keyboardType: TextInputType.text,
                  controller: password,
                  obscureText: true,
                )),
              ],

            ),

            Row(
              children: [
                Text('Confirm Password'),
                SizedBox(width: 15),
                Expanded(child: TextField(
                  keyboardType: TextInputType.text,
                  controller: confirmPassword,
                  obscureText: true,
                ),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: ()async{
                    String Email = email.text.trim();
                    String Password = password.text.trim();
                    String ConfirmPassword = confirmPassword.text.trim();
                    if (Email.isEmpty || Password.isEmpty || ConfirmPassword.isEmpty) {
                      Fluttertoast.showToast(msg: "All fields are required");
                    }else if(Password != ConfirmPassword){
                      Fluttertoast.showToast(msg: "Passwords do not match");
                    }
                    else if (Password == ConfirmPassword) {
                      bool result = await myLogin.signUpUser(Email, Password);
                      if (result == true) {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    }
                  }, child: Text('SignUp')),
                ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text('Cancel')),
              ],
            ),
          ]),
        ));
  }
}
