// ignore_for_file: no_duplicate_case_values

import 'package:cosmatic/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppConstants{
  static String aboutApp = "Get access to wide variety of of indoor and outdoor Cosmatic with just a few taps";
}

void showMessage(String message){

  Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.primaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
        
  );
}




void showLoaderDialog(BuildContext context){
  AlertDialog alertDialog = AlertDialog(
    content:Builder(builder:(context) {
      return SizedBox(
        width: 100,
        child: Row(
          children: [
            CircularProgressIndicator(
              color: AppColor.primaryColor,
            ),
            const SizedBox(width: 20,),
            const Text("Loading...",)
          ],
        ),
      );
    },),
  );

  showDialog(
    barrierDismissible: false,
    context: context,
    builder:(context) {
      return alertDialog;
    },
  );
  
}



String getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";


      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";


      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";


      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";



      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";

      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";


      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";

      default:
        return "Login failed. Please try again.";

    }
  }


bool loginValidation(String email, String password){

  if(email.isEmpty && password.isEmpty){
    showMessage("Please enter email and password");
    return false;
  }
  else  if(email.isEmpty){
    showMessage("Email is required");
    return false;
  }
  else if(password.isEmpty){
    showMessage("Password is required");
    return false;
  }
  else if(!email.contains("@")){
    showMessage("Please enter a valid email address");
    return false;
  }
  else if(password.length<6){
    showMessage("Password should be atleast 6 characters long");
    return false;
  }
  else{
    return true;
  }

}


bool signUpValidation(String email, String password, String name, String phone){

  if(email.isEmpty && password.isEmpty && name.isEmpty && phone.isEmpty ){
    showMessage("Please fill the required fields");
    return false;
  }
  else if(email.isEmpty && password.isEmpty ){
    showMessage("Please enter email and password");
    return false;
  }
  else if(password.isEmpty){
    showMessage("Password is required");
    return false;
  }
  else if(name.isEmpty){
    showMessage("Name is required");
    return false;
  }
  else if(phone.isEmpty){
    showMessage("Phone number is required");
    return false;
  }


  else if(email.isEmpty && password.isEmpty && name.isEmpty && phone.isEmpty){
    showMessage("Please enter email and password");
    return false;
  }
  else if(!email.contains("@")){
    showMessage("Please enter a valid email address");
    return false;
  }
  else if(password.length<6){
    showMessage("Password should be atleast 6 characters long");
    return false;
  }
  else{
    return true;
  }

}