import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  Color color;
  final String text;
  double size;
  TextOverflow overflow;

  BigText(
      {Key? key,
      this.color = const Color(0XFF332d2b),
      // const Color(0XFF332d2b),
      required this.text,
      this.size = 0,
      this.overflow = TextOverflow.ellipsis, required FontWeight fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w400,
        fontSize: size == 0 ? 20 : size,
      ),
    );
  }
}
