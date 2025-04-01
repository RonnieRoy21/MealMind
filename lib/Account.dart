import 'package:fluttertoast/fluttertoast.dart';

class Account{
  static final Account _instance = Account._internal();
  factory Account() => _instance; // Always return the same instance

  Account._internal();// Private constructor


  int balance = 200;



  void depositMoney(int amount) {
    try {
      if (amount <= 0) {
        Fluttertoast.showToast(msg: "Can't deposit null or negative values");
        return; // Exit the function early
      }

      balance += amount;
      Fluttertoast.showToast(
        msg: "Deposit Successful",
        toastLength: Toast.LENGTH_LONG,
      );
      Fluttertoast.showToast(
        msg: "Balance : $balance",
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Deposit Failed: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }


  Future<bool> payFood( int amount)async{
      if (balance >= amount && amount != 0) {
        balance = balance - amount;
        Fluttertoast.showToast(msg: "Payment Successful",
            toastLength: Toast.LENGTH_LONG
        );
        return true;
      } else {
        Fluttertoast.showToast(msg: "Not Enough Balance",
            toastLength: Toast.LENGTH_LONG
        );
        Fluttertoast.showToast(msg: "Balance : $balance",toastLength: Toast.LENGTH_LONG);
        return false;
      }
    }
  }
