import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Routes{


  static Future<dynamic> pushAndRemoveUntill(Widget widget, BuildContext context){
    FocusScope.of(context).unfocus();
    return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder:(context) => widget,), (route) => false
    );
  }



  static Future<dynamic> push(Widget widget, BuildContext context){
    FocusScope.of(context).unfocus();
    return Navigator.of(context).push(
      PageTransition(child: widget, type: PageTransitionType.fade ,duration: const Duration(milliseconds: 250) ,reverseDuration: const Duration(milliseconds: 250))
    );
    
  }


    static Future<dynamic> pushReplacement(Widget widget, BuildContext context){
      FocusScope.of(context).unfocus();
    return Navigator.of(context).pushReplacement(
      PageTransition(child: widget, type: PageTransitionType.fade ,duration: const Duration(milliseconds: 250) ,reverseDuration: const Duration(milliseconds: 250))
    );
  }
}