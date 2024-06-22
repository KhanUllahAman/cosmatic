
import 'package:cosmatic/models/catalouge_model/catalouge_model.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:flutter/material.dart';


class CatalougeDetails extends StatefulWidget {
  CatalougeModel catalougeItem;
  CatalougeDetails({super.key, required this.catalougeItem});

  @override
  State<CatalougeDetails> createState() => _CatalougeDetailsState();
}

class _CatalougeDetailsState extends State<CatalougeDetails> {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Scaffold(


      appBar: AppBar(
        title:Text(widget.catalougeItem.category, style: TextStyle(color: AppColor.primaryColor)),
        centerTitle: true,
      ),



      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(
              height: size.height*0.35,
              child: Card(
                color: AppColor.imgBgColor,
                elevation: 0.2,
                child: Image.network(widget.catalougeItem.image, width: 300),
              ),
            ),
          
            const SizedBox(
              height: 8,
            ),
          

            Text(widget.catalougeItem.name,
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w600)),
          
            const SizedBox(
              height: 10,
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( widget.catalougeItem.category=="Cosmw"?"Cosme species: " : "Acessory usage: ",style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                Text(widget.catalougeItem.usageSpecies , style: TextStyle(fontSize: 15, color: AppColor.subTitleColor),)
              ],
            ),
          
            const Text("Product Description",style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 5,
            ),
            Text(widget.catalougeItem.description,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 15, color: AppColor.subTitleColor)),
          
            const SizedBox(
              height: 15,
            ),          
          ],
        ),
      ),
    );
  }
}
