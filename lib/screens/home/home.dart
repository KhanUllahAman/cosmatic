import 'package:auto_size_text/auto_size_text.dart';
import 'package:cosmatic/chats/chats.dart';
import 'package:cosmatic/firebase_helper/firebase_firestore_helper/firebase_firestore_helper.dart';
import 'package:cosmatic/models/category_model/category_model.dart';
import 'package:cosmatic/models/products_model/products_model.dart';
import 'package:cosmatic/provider/app_provider.dart';
import 'package:cosmatic/screens/cart_screen/cart_screen.dart';
import 'package:cosmatic/screens/product_details/product_details.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/routes.dart';
import 'package:cosmatic/widgets/textfields/custom_searchField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  List<CategoryModel> categoryList = [];
  List<ProductModel> topProductsList = [];
  List<ProductModel> accessoriesList = [];
  List<ProductModel> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

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
    final size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;
    String chatId = user!.uid + 'admin';
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
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CartScreen()));
                                    },
                                    child: Consumer<AppProvider>(
                                      builder: (context, value, child) =>
                                          Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: badges.Badge(
                                          showBadge:
                                              value.cartProdcutList.isEmpty
                                                  ? false
                                                  : true,
                                          badgeStyle: badges.BadgeStyle(
                                            padding: const EdgeInsets.all(5),
                                            badgeColor: Colors.white,
                                          ),
                                          badgeContent: Text(
                                            value.badgeNum.toString(),
                                            style: TextStyle(
                                                color: AppColor.primaryColor),
                                          ),
                                          child: Icon(
                                              EneftyIcons.shopping_bag_bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  )
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
                                    return ProductCardd(
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.primaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        chatId: chatId,
                      )),
            );
          },
          child: Icon(
            Icons.chat_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ProductCardd extends StatelessWidget {
  String prodName;
  String prodImage;
  String prodPrice;
  String prodCategory;
  String prodUsageSpecies;
  ProductModel onPress;
  ProductCardd(
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
      onTap: () => Routes.push(ProductDetail(singleProduct: onPress), context),
      child: Card(
        elevation: 3,
        color: Colors.white,
        surfaceTintColor: Colors.white,
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
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //   child: AutoSizeText(
            //     prodCategory,
            //     style: TextStyle(fontSize: 14, color: Colors.grey),
            //     maxLines: 1,
            //     minFontSize: 10,
            //   ),
            // ),
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
                '\Rs ${prodPrice.toString()}',
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
