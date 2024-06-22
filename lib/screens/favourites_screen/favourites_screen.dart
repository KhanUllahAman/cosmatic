
import 'package:cosmatic/provider/app_provider.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/asset_images.dart';
import 'package:cosmatic/widgets/cards/fav_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(

      appBar: AppBar(
        title: Text("Favourites",style: TextStyle(color: AppColor.primaryColor)),
        centerTitle: true,
      ),

      ///body here
      body: appProvider.favProductList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 70,
                  ),

                  Image.asset(AssetImages().favImage,width: size.width*0.5,),
                  Text("No favourites yet!",style: TextStyle(color: AppColor.primaryColor,fontSize: 22,fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Text("Save your favourite products and find them here later.",style: TextStyle(color: AppColor.subTitleColor, fontSize: 16),textAlign: TextAlign.center),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  ///shop now button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                    ),
                    child: const Text("Shop now",style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            )

          : ListView.builder(
              itemCount: appProvider.favProductList.length,
              itemBuilder: (context, index) {
                return FavCard(
                    singleProduct: appProvider.favProductList[index]
                 );
              },
            ),
    );
  }
}
