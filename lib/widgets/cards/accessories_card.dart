
import 'package:cosmatic/models/products_model/products_model.dart';
import 'package:cosmatic/screens/product_details/product_details.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class AccessoriesCard extends StatelessWidget {

  String accessName;
  String accessImage;
  String accessPrice;
  String accessCategory;
  ProductModel onPress; 
  AccessoriesCard({super.key, 

    required this.accessName,
    required this.accessImage,
    required this.accessPrice,
    required this.accessCategory,
    required this.onPress
  });

  

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap:() => Routes.push(ProductDetail(singleProduct: onPress), context),
      child: SizedBox(
        width: size.width/2.1,
        child: Card(
            color: AppColor.cardBgColor,
            elevation: 0,
            shadowColor: AppColor.primaryColor,
            surfaceTintColor: AppColor.primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Card(
                    elevation: 0,
                    color: AppColor.imgBgColor,
                    child: SizedBox(
                        width: size.width * 0.45,
                        height: size.height*0.165,
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: accessImage,
                          fadeInDuration: const Duration(milliseconds: 300),
                        )),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          accessName,
                          style: TextStyle(fontSize: size.width * 0.045, color: AppColor.titleColor),
                        ),
      
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
      
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 50),
                              child: Text(
                                "Rs.$accessPrice",
                                style:
                                    TextStyle(color: AppColor.primaryColor, fontSize: size.width*0.055, fontWeight: FontWeight.bold),
                              ),
                            ),
                            
                    
                            CircleAvatar(
                              
                              backgroundColor: AppColor.secondaryLightColor,                        
                              child: Icon(Icons.add, color: AppColor.primaryColor,)
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ),
      ),
    );
  }
}







