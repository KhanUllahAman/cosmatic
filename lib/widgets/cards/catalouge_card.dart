



import 'package:cosmatic/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CatalougeCard extends StatefulWidget {

  String image;
  String title;
  String subTitle;
  final void Function()? onPress;




  CatalougeCard({required this.image, required this.title, required this.subTitle , required this.onPress ,super.key});

  @override
  State<CatalougeCard> createState() => _CatalougeCardState();
}

class _CatalougeCardState extends State<CatalougeCard> {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap:widget.onPress,
      child: Hero(
        tag: widget.image,
        child: Card(
          elevation: 0,
          color: AppColor.cardBgColor,
          child: SizedBox(
            height: size.height * 0.14,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Card(
                    color: AppColor.imgBgColor,
                    elevation: 0,
                    child: Image.network(widget.image),
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(fontSize: size.width * 0.055),
                          ),
          
                          Text(
                            widget.subTitle,
                            style: TextStyle(fontSize: size.width * 0.05, color: AppColor.subTitleColor),
                          ),
          
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}