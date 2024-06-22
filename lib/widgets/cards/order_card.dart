// ignore_for_file: must_be_immutable


import 'package:cosmatic/utils/app_colors.dart';
import 'package:flutter/material.dart';


class OrderCard extends StatefulWidget {

  String orderImage;
  String orderName;
  String totalPrice;
  String quantity;
  String status;



  OrderCard({super.key, required this.orderImage, required this.orderName, required this.totalPrice, required this.quantity, required this.status});



  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  int quantity = 1;
  
  



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      elevation: 0,
      color: AppColor.cardBgColor,
      child: SizedBox(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Card(
                color: AppColor.imgBgColor,
                elevation: 0,
                child: Image.network(widget.orderImage),
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.orderName,
                            style: TextStyle(fontSize: size.width * 0.05),
                          ),
                          Text(
                            "Price: Rs.${widget.totalPrice}",
                            style: TextStyle(
                                fontSize: size.width * 0.04,
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Quantity: ${widget.quantity}",
                            style: TextStyle(fontSize: size.width * 0.04,
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.w500
                            
                            ),
                          ),

                          Text(
                            "Status: ${widget.status}",
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w500
                            
                            ),

                            
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
