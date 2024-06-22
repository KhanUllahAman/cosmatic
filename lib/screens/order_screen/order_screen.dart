import 'package:auto_size_text/auto_size_text.dart';
import 'package:cosmatic/firebase_helper/firebase_firestore_helper/firebase_firestore_helper.dart';
import 'package:cosmatic/models/order_model/order_model.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/asset_images.dart';
import 'package:cosmatic/widgets/cards/order_card.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: AutoSizeText(
          "Orders",
          style: TextStyle(color: AppColor.primaryColor),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestoreHelper.instance.getUserOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AssetImages().noOrdersImage, width: 200),
                  AutoSizeText("No orders found!",
                      style: TextStyle(
                          fontSize: 20,
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w600))
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                OrderModel orderModel = snapshot.data![index];
                return ExpansionTile(
                    iconColor: orderModel.products.length > 1
                        ? AppColor.primaryColor
                        : Colors.transparent,
                    collapsedIconColor: orderModel.products.length > 1
                        ? AppColor.primaryColor
                        : Colors.transparent,
                    tilePadding: EdgeInsets.zero,
                    collapsedBackgroundColor: AppColor.cardBgColor,
                    backgroundColor: AppColor.cardBgColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: AppColor.cardBgColor)),
                    collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: AppColor.cardBgColor)),
                    title: orderModel.products.length > 1
                        ? const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: AutoSizeText("See ordered Items"),
                          )
                        : OrderCard(
                            orderImage: orderModel.products[0].image,
                            orderName: orderModel.products[0].name,
                            totalPrice: orderModel.totalPrice.toString(),
                            quantity:
                                orderModel.products[0].quantity.toString(),
                            status: orderModel.status,
                          ),
                    children: orderModel.products.length > 1
                        ?
                        orderModel.products.map((item) {
                            return OrderCard(
                                orderImage: item.image,
                                orderName: item.name,
                                totalPrice: item.price,
                                quantity: item.quantity.toString(),
                                status: item.status);
                          }).toList()
                        :
                        []);
              },
            ),
          );
        },
      ),
    );
  }
}