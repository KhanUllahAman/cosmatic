import 'package:cosmatic/firebase_helper/firebase_firestore_helper/firebase_firestore_helper.dart';
import 'package:cosmatic/models/products_model/products_model.dart';
import 'package:cosmatic/provider/app_provider.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/widgets/cards/payment_card.dart';
import 'package:cosmatic/widgets/primary_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class CartCheckOut extends StatefulWidget {
  const CartCheckOut({super.key});

  @override
  State<CartCheckOut> createState() => _CartCheckOutState();
}

class _CartCheckOutState extends State<CartCheckOut> {
  int _selectedOption = 1;

  @override
  void initState() {
    super.initState();
    _selectedOption = 1;
  }

  Future<void> _showFeedbackDialog(BuildContext context, List<ProductModel> products) async {
    final feedbackController = TextEditingController();
    double rating = 0;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Feedback'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please provide feedback for your order.'),
                TextField(
                  controller: feedbackController,
                  decoration: InputDecoration(
                    hintText: 'Enter your feedback here',
                  ),
                ),
                SizedBox(height: 20),
                Text('Rate your experience:'),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (double value) {
                    rating = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancel")),
            TextButton(
              child: Text('Send'),
              onPressed: () {
                FirebaseFirestoreHelper.instance.postFeedback(products, feedbackController.text, rating);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout", style: TextStyle(color: AppColor.primaryColor)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            PaymentCard(
              icon: "assets/icons/mastercard.svg",
              name: "Online Payment",
              btnValue: 1,
              btnGroupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value!;
                });
              },
            ),
            PaymentCard(
              icon: "assets/icons/cash.svg",
              name: "Cash on delivery",
              btnValue: 2,
              btnGroupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value!;
                });
              },
            ),
            const Spacer(),
            PrimaryButton(
              title: "Make payment",
              backgroundColor: AppColor.primaryColor,
              onPressed: () async {
                Future<bool> isOrdered = FirebaseFirestoreHelper.instance
                    .postOrderedItemFirebase(
                        appProvider.getBuyItemList,
                        context,
                        _selectedOption == 1
                            ? "Online Payment"
                            : "Cash on delivery");
                
                if (await isOrdered) {
                  await _showFeedbackDialog(context, appProvider.getBuyItemList);
                  Future.delayed(const Duration(seconds: 2), () {
                    appProvider.clearBuyProduct();
                    appProvider.clearCart();
                    Navigator.of(context).pop();
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

