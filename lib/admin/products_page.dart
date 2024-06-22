import 'package:cosmatic/admin/edit_product_page.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  ProductsPage({required this.categoryId, required this.categoryName});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> _fetchProducts() async {
    QuerySnapshot snapshot = await _firestore
        .collection('categories')
        .doc(widget.categoryId)
        .collection('items')
        .get();
    return snapshot.docs;
  }

  void _editProduct(DocumentSnapshot doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditProductPage(productDoc: doc, categoryId: widget.categoryId),
      ),
    );
  }

  void _deleteProduct(DocumentSnapshot doc) async {
    await _firestore
        .collection('categories')
        .doc(widget.categoryId)
        .collection('items')
        .doc(doc.id)
        .delete();
    setState(() {});
  }

  void _showDeleteConfirmationDialog(DocumentSnapshot doc) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteProduct(doc);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColor.primaryColor,
        title: Text(widget.categoryName, style: TextStyle(color: Colors.white)),
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
            return Center(child: Text('No products found.'));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data![index];
              return Card(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    doc['image'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Image.network(
                              doc['image'],
                              width: double.infinity,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child:
                                Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Price: \$${doc['price']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: AppColor.primaryColor),
                                onPressed: () => _editProduct(doc),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: AppColor.primaryColor),
                                onPressed: () =>
                                    _showDeleteConfirmationDialog(doc),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
