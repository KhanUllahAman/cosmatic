// ignore_for_file: must_be_immutable


import 'package:cosmatic/models/products_model/products_model.dart';
import 'package:cosmatic/provider/app_provider.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavCard extends StatefulWidget {
  FavCard({super.key, required this.singleProduct});

  ProductModel singleProduct;

  @override
  State<FavCard> createState() => _FavCardState();
}

class _FavCardState extends State<FavCard> {
  int quantity = 1;
  
  

  @override
  void initState() {
    quantity = widget.singleProduct.quantity??1;
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      elevation: 3,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: SizedBox(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Card(
                color: Color.fromARGB(255, 247, 194, 212),
                elevation: 0,
                child: Image.network(widget.singleProduct.image),
              ),
            ),
            Expanded(
                flex: 4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.singleProduct.name,
                        style: TextStyle(fontSize: size.width * 0.05),
                      ),
                      Text(
                        "Rs.${widget.singleProduct.price}",
                        style: TextStyle(
                            fontSize: size.width * 0.04,
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Text("Status: ${widget.singleProduct.status}", style: TextStyle(color: AppColor.primaryColor),),

                      Consumer<AppProvider>(
                        builder:(context, value, child) => GestureDetector(
                          onTap: () {
                             value.removeFromFav(widget.singleProduct);
                             showMessage("Removed from Favourites");
                          },
                          child: Text(
                            "Remove from Favourites",
                            style: TextStyle(
                              color: AppColor.secondaryColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
