
import 'package:cosmatic/utils/app_colors.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {

  TextEditingController textEditingController;
  bool isVisible;
  
  CustomPasswordField({super.key, required this.textEditingController, required this.isVisible});

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07), 
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 1.5), 
          )
        ]),
        child: TextFormField(
          controller: widget.textEditingController,
          obscureText: !widget.isVisible,
          style: TextStyle(color: AppColor.subTitleColor),
          decoration: InputDecoration(
              prefixIcon: Icon(EvaIcons.lockOutline , color: AppColor.iconColor,),
              hintText: "Password",
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.isVisible = !widget.isVisible;
                  });
                },
                child: Icon(widget.isVisible ? EvaIcons.eyeOutline : EvaIcons.eyeOffOutline, color: AppColor.iconColor,),
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: AppColor.textfieldColor,
              contentPadding: const EdgeInsets.all(18)),
        ),
      ),
    );
  }
}