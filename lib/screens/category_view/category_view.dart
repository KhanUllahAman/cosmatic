// ignore_for_file: must_be_immutable


import 'package:cosmatic/firebase_helper/firebase_firestore_helper/firebase_firestore_helper.dart';
import 'package:cosmatic/models/category_model/category_model.dart';
import 'package:cosmatic/models/products_model/products_model.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/widgets/cards/product_card.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatefulWidget {
  CategoryModel categoryModel;
  CategoryView({required this.categoryModel, super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {

  
  bool isLoading = false;
  List<ProductModel> categoryProdList = [];
 
  getCategoryList() async {
    setState(() {
      isLoading = true;
    });

    categoryProdList = await FirebaseFirestoreHelper.instance.getCategoryProducts(widget.categoryModel.id);
    categoryProdList.shuffle();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories",style: TextStyle(color: AppColor.primaryColor)),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(widget.categoryModel.name,style: const TextStyle(fontSize: 22)),
                  const SizedBox(
                    height: 10,
                  ),
                  
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65),
                    itemCount: categoryProdList.length,
                    itemBuilder: (context, index) {
                      ProductModel singleProduct = categoryProdList[index];
                      return ProductCard(
                        prodName: singleProduct.name,
                        prodImage: singleProduct.image,
                        prodPrice: singleProduct.price,
                        prodCategory: singleProduct.category,
                        prodUsageSpecies: singleProduct.usageSpecies,
                        onPress: singleProduct,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
