import 'package:cosmatic/firebase_helper/firebase_firestore_helper/firebase_firestore_helper.dart';
import 'package:cosmatic/models/order_model/order_model.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/asset_images.dart';
import 'package:flutter/material.dart';

class ViewOrders extends StatelessWidget {
  const ViewOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColor.primaryColor,
        title: Text(
          "Orders",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: FirebaseFirestoreHelper.instance.getUserOrders(),
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
                  Text(
                    "No orders found!",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                List<Widget> orderWidgets = [];

                for (var product in orderModel.products) {
                  orderWidgets.add(
                    Card(
                      elevation: 2,
                      child: ListTile(
                        leading: Image.network(
                          product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Price: \$${product.price}"),
                            Text("Quantity: ${product.quantity}"),
                            Text("Status: ${product.status}"),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                orderWidgets.insert(
                  0,
                  Text(
                    "User Email: ${orderModel.userEmail}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: orderWidgets,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
