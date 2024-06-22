
import 'package:cosmatic/firebase_helper/firebase_firestore_helper/firebase_firestore_helper.dart';
import 'package:cosmatic/models/products_model/products_model.dart';
import 'package:cosmatic/provider/app_provider.dart';
import 'package:cosmatic/screens/cart_checkout/cart_checkout.dart';
import 'package:cosmatic/screens/home/home.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/asset_images.dart';
import 'package:cosmatic/utils/routes.dart';
import 'package:cosmatic/utils/sizebox.dart';
import 'package:cosmatic/widgets/cards/cart_card.dart';
import 'package:cosmatic/widgets/primary_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  List<ProductModel> topProductsList = [];
  bool isLoading = false;


  getProductData() async {
    setState(() {
      isLoading = true;
    });

    topProductsList =await FirebaseFirestoreHelper.instance.getTopSellingProducts();
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


    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      
      appBar: AppBar(
        title: Text("My Cart",style: TextStyle(color: AppColor.primaryColor),),
        centerTitle: true,
      ),

      body: appProvider.cartProdcutList.isEmpty? isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 230,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(AssetImages().emptyCartImage,width: size.width*0.4),
                              Text("Your cart is Empty!",style: TextStyle(fontSize:size.width*0.06 , color: AppColor.primaryColor, fontWeight: FontWeight.w600))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24,),

                      Text("Empty cart? Discover new favorites!",style: TextStyle(color: AppColor.titleColor,fontSize:size.width*0.06,fontWeight: FontWeight.bold),),
                     5.ph,


                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65),
                        itemCount: topProductsList.length,
                        itemBuilder: (context, index) {
                          ProductModel singleProduct = topProductsList[index];
                          return ProductCardd(
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
                )


          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: appProvider.cartProdcutList.length,
                      itemBuilder: (context, index) {
                        return CartCard(
                            singleProduct: appProvider.cartProdcutList[index]);
                      },
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total:",style: TextStyle(fontSize: size.width*0.05,fontWeight: FontWeight.w500,color: AppColor.subTitleColor)),
                            Text("Rs.${appProvider.totalPrice()}",style: TextStyle(color: AppColor.primaryColor, fontSize: size.width*0.055, fontWeight: FontWeight.bold))
                          ],
                        ),

                        30.pw,

                        Expanded(
                          child: PrimaryButton(
                            onPressed:() {
                              appProvider.clearBuyProduct();
                              appProvider.addBuyProductCartList();

                              Routes.push(const CartCheckOut(), context);
                            }, 
                            title: "Checkout", 
                            backgroundColor: AppColor.primaryColor
                          ),
                        )
                      ],
                    ),
                  ),
                  10.ph

                ],
              ),
            ),
    );
  }
}
