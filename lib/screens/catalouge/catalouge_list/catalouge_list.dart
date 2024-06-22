// ignore_for_file: must_be_immutable

import 'package:cosmatic/firebase_helper/firebase_firestore_helper/firebase_firestore_helper.dart';
import 'package:cosmatic/models/catalouge_model/catalouge_model.dart';
import 'package:cosmatic/models/category_model/category_model.dart';
import 'package:cosmatic/screens/catalouge/catalouge_details.dart/catalouge_detail.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/routes.dart';
import 'package:cosmatic/widgets/cards/catalouge_card.dart';
import 'package:flutter/material.dart';


class CatalougeList extends StatefulWidget {
  CategoryModel categoryModel;
  CatalougeList({required this.categoryModel, super.key});

  @override
  State<CatalougeList> createState() => _CatalougeListState();
}

class _CatalougeListState extends State<CatalougeList> {
  bool isLoading = false;
  List<CatalougeModel> catalougeItemList = [];

  getCatalougeItems() async {
    setState(() {
      isLoading = true;
    });

    catalougeItemList = await FirebaseFirestoreHelper.instance
        .getCatalougeItems(widget.categoryModel.id);
    catalougeItemList.shuffle();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getCatalougeItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Catalouge", style: TextStyle(color: AppColor.primaryColor)),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          :                   ListView.builder(
                    itemCount: catalougeItemList.length,
                    itemBuilder: (context, index) {
                      return CatalougeCard(

                        image: catalougeItemList[index].image,
                        title: catalougeItemList[index].name,
                        subTitle: catalougeItemList[index].category,
                        onPress: () {
                          Routes.push(CatalougeDetails(catalougeItem: catalougeItemList[index]), context);
                        },

                      );
                    },
                  ),
    );
  }
}