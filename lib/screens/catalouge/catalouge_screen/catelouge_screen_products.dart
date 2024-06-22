
// import 'package:cosmatic/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserProductsPage extends StatefulWidget {
//   final String categoryId;
//   final String categoryName;

//   UserProductsPage({required this.categoryId, required this.categoryName});

//   @override
//   _UserProductsPageState createState() => _UserProductsPageState();
// }

// class _UserProductsPageState extends State<UserProductsPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<DocumentSnapshot>> _fetchProducts() async {
//     QuerySnapshot snapshot = await _firestore
//         .collection('categories')
//         .doc(widget.categoryId)
//         .collection('items')
//         .get();
//     return snapshot.docs;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: Text(widget.categoryName, style: TextStyle(color: AppColor.primaryColor)),
//       ),
//       body: FutureBuilder<List<DocumentSnapshot>>(
//         future: _fetchProducts(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Image.asset('assets/images/no.jpg', width: 150, height: 150,));
//           }

//           return GridView.builder(
//             padding: EdgeInsets.all(10),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               childAspectRatio: 3 / 4,
//             ),
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               var doc = snapshot.data![index];
//               return GestureDetector(
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   elevation: 5,
//                   clipBehavior: Clip.antiAliasWithSaveLayer,
//                   child: Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: NetworkImage(doc['image']),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Colors.black.withOpacity(0.7), Colors.transparent],
//                             begin: Alignment.bottomCenter,
//                             end: Alignment.topCenter,
//                             stops: [0.0, 0.7],
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 doc['name'],
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               SizedBox(height: 5),
//                               Text(
//                                 '\$${doc['price']}',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cosmatic/models/products_model/products_model.dart';
import 'package:cosmatic/screens/product_details/product_details.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProductsPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  UserProductsPage({required this.categoryId, required this.categoryName});

  @override
  _UserProductsPageState createState() => _UserProductsPageState();
}

class _UserProductsPageState extends State<UserProductsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> _fetchProducts() async {
    QuerySnapshot snapshot = await _firestore
        .collection('categories')
        .doc(widget.categoryId)
        .collection('items')
        .get();
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(widget.categoryName, style: TextStyle(color: AppColor.primaryColor)),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Image.asset('assets/images/no.jpg', width: 150, height: 150,));
          }

          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 4,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetail(
                        singleProduct: ProductModel(
                          id: doc.id,
                          name: doc['name'],
                          description: doc['description'],
                          price: doc['price'].toString(),
                          image: doc['image'],
                          isFav: false, category: '', usageSpecies: '', status: '',
                          // Add other fields as necessary
                        ),
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(doc['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [0.0, 0.7],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                doc['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),
                              Text(
                                '\$${doc['price']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
