
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmatic/firebase_helper/firebase_firestore_helper/firebase_firestore_helper.dart';
import 'package:cosmatic/firebase_helper/firebase_storage/firebase_storage.dart';
import 'package:cosmatic/models/products_model/products_model.dart';
import 'package:cosmatic/models/user_model/user_model.dart';
import 'package:cosmatic/utils/constants.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  //cart provider
  final List<ProductModel> _cartProductList = [];
  final List<ProductModel> _buyItemList = [];
  UserModel? _userModel;

  UserModel get getUserInfo => _userModel!;
  List<ProductModel> get favProductList => _favProductList;

  int _badgeNum = 0;
  int get badgeNum => _badgeNum;

    void badgeCount() {
    _badgeNum = _cartProductList.length;
    notifyListeners();
  }


  void addToCart(ProductModel productModel) {
    _cartProductList.add(productModel);
    badgeCount();
    notifyListeners();
  }

  void removeFromCart(ProductModel productModel) {
    _cartProductList.remove(productModel);
    badgeCount();
    notifyListeners();
  }


  List<ProductModel> get cartProdcutList => _cartProductList;

  final List<ProductModel> _favProductList = [];

  void addToFav(ProductModel productModel) {
    _favProductList.add(productModel);
    notifyListeners();
  }

  void removeFromFav(ProductModel productModel) {
    _favProductList.remove(productModel);
    notifyListeners();
  }
  


  getUserInfoFirebase() async {
    _userModel = await FirebaseFirestoreHelper.instance.getUserInfo();
    notifyListeners();
  }


void updateUserInfoFirebase(UserModel userModel, File? file, BuildContext context) async {
  if (file == null) {
    showLoaderDialog(context);

    _userModel = userModel;
    await FirebaseFirestore.instance.collection("users").doc(userModel.id).set(userModel.toJson());
    showMessage("Profile updated successfully!");
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pop();
  } else {
    showLoaderDialog(context);
    String imageUrl = await FirebaseStorageHelper.firebaseStorageHelper.uploadUserImage(file);

    _userModel = userModel.copyWith(image: imageUrl);
    await FirebaseFirestore.instance.collection("users").doc(userModel.id).set(userModel.toJson());

    showMessage("Profile updated successfully!");
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pop();
  }
    notifyListeners();
}





double totalPrice(){
  double totalPrice = 0.00;
  for(var element in _cartProductList){

    var qty = element.quantity!.toDouble();
    var price= double.parse(element.price);


    totalPrice += price * qty;
  }
  return totalPrice;
  
}


void updateQty(ProductModel productModel, int qty){



  int index = _cartProductList.indexOf(productModel);
  _cartProductList[index].quantity = qty;
  notifyListeners();


  
}




List<ProductModel> get getBuyItemList =>  _buyItemList;

void addToBuyItem(ProductModel productModel){
  _buyItemList.add(productModel);
  notifyListeners();
}


void addBuyProductCartList(){
  _buyItemList.addAll(_cartProductList);
  notifyListeners();
}


void clearCart(){
  _cartProductList.clear();
  notifyListeners();
}



void clearBuyProduct(){
  _buyItemList.clear();
  notifyListeners();
}



}
