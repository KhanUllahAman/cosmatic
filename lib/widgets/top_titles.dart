// ignore_for_file: must_be_immutable

import 'package:cosmatic/utils/app_colors.dart';
import 'package:flutter/material.dart';

class Toptitles extends StatelessWidget {
  
  String primary, secondary;
  Toptitles({required this.primary, required this.secondary, super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          primary,
          style: TextStyle(color: Colors.black.withAlpha(200), fontSize: size.width * 0.08, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4,),
        Text(
          secondary,
          style: TextStyle(fontSize: size.width * 0.05, color: AppColor.subTitleColor),
        ),
      ],
    );
  }
}
