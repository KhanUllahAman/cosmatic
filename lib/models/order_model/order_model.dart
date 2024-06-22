import 'dart:convert';
import 'package:cosmatic/models/products_model/products_model.dart';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

class OrderModel {
  OrderModel({
    required this.orderId,
    required this.payment,
    required this.products,
    required this.status,
    required this.totalPrice,
    required this.userEmail,
  });

  String orderId;
  String payment;
  List<ProductModel> products;
  String status;
  double totalPrice;
  String userEmail;

  factory OrderModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON must not be null");
    }

    List<dynamic> productMap = json["products"] ?? [];

    return OrderModel(
      orderId: json["orderId"] ?? '',
      payment: json["payment"] ?? '',
      products: productMap.map((e) => ProductModel.fromJson(e)).toList(),
      status: json["status"] ?? '',
      totalPrice: (json["totalPrice"] ?? 0).toDouble(),
      userEmail: json['useremail'] ?? '',
    );
  }
}
