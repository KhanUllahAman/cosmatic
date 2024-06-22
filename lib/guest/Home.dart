import 'package:auto_size_text/auto_size_text.dart';
import 'package:cosmatic/firebase_helper/firebase_firestore_helper/firebase_firestore_helper.dart';
import 'package:cosmatic/guest/product_detail.dart';
import 'package:cosmatic/models/category_model/category_model.dart';
import 'package:cosmatic/models/products_model/products_model.dart';
import 'package:cosmatic/provider/app_provider.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/routes.dart';
import 'package:cosmatic/widgets/textfields/custom_searchField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enefty_icons/enefty_icons.dart';

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key});
  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  bool isLoading = false;
  List<CategoryModel> categoryList = [];
  List<ProductModel> topProductsList = [];
  List<ProductModel> accessoriesList = [];
  List<ProductModel> filteredProducts = [];
  TextEditingController searchController = TextEditingController();
  String getGreeting() {
    final currentTime = DateTime.now().hour;
    if (currentTime >= 5 && currentTime < 12) {
      return 'Good Morning!';
    } else if (currentTime >= 12 && currentTime < 17) {
      return 'Good Afternoon';
    } else if (currentTime >= 17 && currentTime < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  getProductData() async {
    setState(() {
      isLoading = true;
    });
    categoryList = await FirebaseFirestoreHelper.instance.getCategories();
    accessoriesList =
        await FirebaseFirestoreHelper.instance.getAccessoryProducts();
    topProductsList =
        await FirebaseFirestoreHelper.instance.getTopSellingProducts();
    topProductsList.shuffle();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getProductData();
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
  }

  @override
  Widget build(BuildContext context) {
    String greeting = getGreeting();
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                      height: 150,
                      width: 1000,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/logo.png",
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Row(
                                children: [
                                  AutoSizeText(
                                    'Paris Cosmatics',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                        child: Icon(
                                            EneftyIcons.shopping_bag_bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SearchField(
                            controller: searchController,
                            onChanged: (value) {
                              setState(() {
                                filteredProducts = topProductsList
                                    .where((product) => product.name
                                        .toLowerCase()
                                        .contains(searchController.text
                                            .toLowerCase()))
                                    .toList();
                              });
                            },
                          ),
                          filteredProducts.isEmpty && searchController.text.isNotEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      "No products are found",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.65),
                                  itemCount: filteredProducts.isEmpty
                                      ? topProductsList.length
                                      : filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    ProductModel singleProduct =
                                        filteredProducts.isEmpty
                                            ? topProductsList[index]
                                            : filteredProducts[index];
                                    return ProductCard(
                                      prodName: singleProduct.name,
                                      prodImage: singleProduct.image,
                                      prodCategory: singleProduct.category,
                                      prodUsageSpecies:
                                          singleProduct.usageSpecies,
                                      onPress: singleProduct,
                                      prodPrice: singleProduct.price,
                                    );
                                  },
                                )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  String prodName;
  String prodImage;
  String prodPrice;
  String prodCategory;
  String prodUsageSpecies;
  ProductModel onPress;
  ProductCard(
      {super.key,
      required this.prodName,
      required this.prodImage,
      required this.prodPrice,
      required this.prodCategory,
      required this.prodUsageSpecies,
      required this.onPress});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Routes.push(GuestProductDetail(singleProduct: onPress), context),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              prodImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 115,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                prodName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 2,
                minFontSize: 12,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AutoSizeText(
                prodCategory,
                style: TextStyle(fontSize: 14, color: Colors.grey),
                maxLines: 1,
                minFontSize: 10,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AutoSizeText(
                prodUsageSpecies,
                style: TextStyle(fontSize: 14, color: Colors.grey),
                maxLines: 1,
                minFontSize: 10,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AutoSizeText(
                '\$${prodPrice.toString()}',
                style: TextStyle(fontSize: 16, color: AppColor.primaryColor),
                maxLines: 1,
                minFontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
