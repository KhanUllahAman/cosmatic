
import 'package:flutter/material.dart';


class PrimaryButton extends StatelessWidget {
  String title;
  Color backgroundColor;
  final void Function()? onPressed;
  PrimaryButton({required this.onPressed,required this.title,required this.backgroundColor,super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 50,
      child: ElevatedButton(
        
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0
        ),
        
        onPressed: onPressed,
        child: Text(title, style: TextStyle(color: Colors.white,fontSize: size.width*0.050)),
      ),
    );
  }
}
