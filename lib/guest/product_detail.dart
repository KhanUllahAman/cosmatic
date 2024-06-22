import 'package:carousel_slider/carousel_slider.dart';
import 'package:cosmatic/firebase_helper/firebase_firestore_helper/firebase_firestore_helper.dart';
import 'package:cosmatic/models/products_model/products_model.dart';
import 'package:cosmatic/provider/app_provider.dart';
import 'package:cosmatic/screens/auth_screens/login_ui/login.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:enefty_icons/enefty_icons.dart';

class GuestProductDetail extends StatefulWidget {
  ProductModel singleProduct;
  GuestProductDetail({required this.singleProduct, super.key});

  @override
  State<GuestProductDetail> createState() => _GuestProductDetailState();
}

class _GuestProductDetailState extends State<GuestProductDetail> {
  bool isFav = true;
  int quantity = 1;
  List<Map<String, dynamic>> feedbacks = [];

  @override
  void initState() {
    super.initState();
    fetchFeedback();
  }

  Future<void> fetchFeedback() async {
    feedbacks = await FirebaseFirestoreHelper.instance
        .getProductFeedback(widget.singleProduct.id);
    setState(() {});
  }

  String formatProductName(String name) {
    if (name.length <= 25) return name;
    List<String> parts = [];
    for (int i = 0; i < name.length; i += 25) {
      parts.add(name.substring(i, i + 25 > name.length ? name.length : i + 25));
    }
    return parts.join('\n');
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Product details", style: TextStyle(color: AppColor.primaryColor)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: SingleChildScrollView( // Scrollable part
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 280,
                      child: Card(
                        color: Color.fromARGB(255, 247, 194, 212),
                        elevation: 0.2,
                        child: Image.network(widget.singleProduct.image, width: size.width),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatProductName(widget.singleProduct.name),
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500),
                            ),
                            Text("Rs.${widget.singleProduct.price}", style: TextStyle(fontSize: 20, color: AppColor.primaryColor, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              child: Icon(
                                widget.singleProduct.isFav ? EneftyIcons.heart_bold : EneftyIcons.heart_outline,
                                color: AppColor.primaryColor,
                                size: 30,
                              ),
                              onTap: () => Routes.push(LoginScreen(), context),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text("Product Description", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 5),
                    Text(widget.singleProduct.description, textAlign: TextAlign.justify, style: TextStyle(fontSize: 15, color: AppColor.subTitleColor)),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        GestureDetector(
                           onTap: () => Routes.push(LoginScreen(), context),
                          child: Card(
                            elevation: 0,
                            color: AppColor.primaryColor,
                            child: const Icon(Icons.remove, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "$quantity",
                            style: TextStyle(fontSize: size.width * 0.05),
                          ),
                        ),
                        GestureDetector(
                           onTap: () => Routes.push(LoginScreen(), context),
                          child: Card(
                            elevation: 0,
                            color: AppColor.primaryColor,
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        )
                      ],
                    ),

                    if (feedbacks.isNotEmpty) ...[
                      const Text("Customer Feedback",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 150,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                        items: feedbacks.map((feedback) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Card(
                                color: Color.fromARGB(255, 246, 214, 224),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 5,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        feedback['feedback'] ?? '',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          RatingBarIndicator(
                                            rating: feedback['rating'] ?? 0.0,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 20.0,
                                            direction: Axis.horizontal,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            '(${feedback['rating'].toString()})',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        feedback['userEmail'] ?? '',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [   
            
                    Consumer<AppProvider>(
                      builder: (context, value, child) => Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: AppColor.primaryColor),
                            onPressed: () {
                               Routes.push(LoginScreen(), context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.cartShopping,
                                  color: AppColor.cardBgColor,
                                  size: 17,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Add to cart",
                                  style:
                                      TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              side: BorderSide(color: AppColor.primaryColor)),
                          onPressed: () {
                            Routes.push(LoginScreen(), context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.dollarSign,
                                color: AppColor.primaryColor,
                                size: 17,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Buy",
                                style: TextStyle(
                                    color: AppColor.primaryColor, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}