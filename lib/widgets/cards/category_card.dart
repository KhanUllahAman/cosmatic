// ignore_for_file: must_be_immutable

import 'package:cosmatic/models/category_model/category_model.dart';
import 'package:cosmatic/screens/category_view/category_view.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';



class CategoryCard extends StatelessWidget {

  String catName;
  String catImage;
  CategoryModel onPress;
  
  CategoryCard({super.key, 
    required this.catName,
    required this.catImage,
    required this.onPress
  });

  @override
  Widget build(BuildContext context) {
        final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () => Routes.push(CategoryView(categoryModel: onPress), context),
        child: Container(
  
          width: size.width*0.35,
          decoration: BoxDecoration(
              color: AppColor.secondaryLightColor,
              // border: Border.all(color: AppColor.primaryColor, width: 1.5),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    catName,
                    style: TextStyle(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.038),
                  ),
                ),
            
                Expanded(
                  flex: 2,
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: catImage,
                    width: size.width*0.05,
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
