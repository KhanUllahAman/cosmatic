import 'package:cosmatic/utils/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme(){

  return ThemeData(
 useMaterial3: true,
 fontFamily: "Noto Sans",
 scaffoldBackgroundColor: AppColor.scaffoldColor,
 primaryColor: AppColor.primaryColor,
 elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColor.primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    )

    
  )
 ),

 progressIndicatorTheme: ProgressIndicatorThemeData(
  color: AppColor.primaryColor
 ),
 
 
 outlinedButtonTheme: OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    ),
    side: BorderSide(
      color: AppColor.secondaryColor,
    )
  )
 ),

 cardTheme: CardTheme(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10)
  )
 ),


 appBarTheme: AppBarTheme(
  backgroundColor: AppColor.scaffoldColor,
  iconTheme: IconThemeData(
    color: AppColor.primaryColor  
  ),
  surfaceTintColor: Colors.transparent,
 ),

 textSelectionTheme: TextSelectionThemeData(
  cursorColor: AppColor.primaryColor
 ),

 dialogBackgroundColor: AppColor.imgBgColor,

 
  );

}







   
