
import 'package:cosmatic/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  IconData prefixIcon;
  String hintText;
  TextEditingController controller;
  TextInputType keyboadType;
  
  CustomTextField({
    super.key, 
    required this.prefixIcon, 
    required this.controller, 
    required this.hintText,
    required this.keyboadType
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07), // Shadow color
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 1.5), // Shadow position
          )
        ]),
        child: TextFormField(
          keyboardType: widget.keyboadType,
          controller: widget.controller,
          style: TextStyle(color: AppColor.subTitleColor, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
              prefixIcon: Icon(widget.prefixIcon, color: AppColor.iconColor),
              hintText: widget.hintText,
              border: InputBorder.none,
              filled: true,
              fillColor: AppColor.textfieldColor,
              contentPadding: const EdgeInsets.all(17)),
        ),
      ),
    );
  }
}
