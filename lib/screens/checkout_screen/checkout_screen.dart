// ignore_for_file: must_be_immutable

import 'package:cosmatic/firebase_helper/firebase_firestore_helper/firebase_firestore_helper.dart';
import 'package:cosmatic/models/products_model/products_model.dart';
import 'package:cosmatic/provider/app_provider.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/widgets/cards/payment_card.dart';
import 'package:cosmatic/widgets/primary_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';


class CheckOut extends StatefulWidget {
  final ProductModel singleProduct;
  double totalPrice;

  CheckOut({required this.singleProduct, required this.totalPrice, super.key});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  int _selectedOption = 1;

  @override
  void initState() {
    super.initState();
    _selectedOption = 1;
    widget.totalPrice = double.parse(widget.singleProduct.price) *
        widget.singleProduct.quantity!;
  }

  Future<void> _showFeedbackDialog(
      BuildContext context, List<ProductModel> products) async {
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
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            TextButton(
              child: Text('Send'),
              onPressed: () {
                FirebaseFirestoreHelper.instance
                    .postFeedback(products, feedbackController.text, rating);
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
    widget.totalPrice = double.parse(widget.singleProduct.price) *
        widget.singleProduct.quantity!;

    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout", style: TextStyle(color: AppColor.primaryColor)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              color: Color.fromARGB(255, 247, 194, 212),
              surfaceTintColor: Color.fromARGB(255, 247, 194, 212),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        widget.singleProduct.image,
                        height: 100,
                        width: 100,
                        // fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      widget.singleProduct.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.singleProduct.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price: Rs.${widget.singleProduct.price}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Quantity: ${widget.singleProduct.quantity}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Divider(
                      color: Colors.grey[400],
                      height: 20,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Total: Rs.${widget.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
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
                        [widget.singleProduct],
                        context,
                        _selectedOption == 1
                            ? "Online Payment"
                            : "Cash on delivery");
        
                if (await isOrdered) {
                  await _showFeedbackDialog(context, [widget.singleProduct]);
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
