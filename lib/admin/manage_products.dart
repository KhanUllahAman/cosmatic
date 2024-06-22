import 'package:cosmatic/admin/categories_page.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/widgets/textfields/big_text.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ManageProducts extends StatefulWidget {
  @override
  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productStatusController = TextEditingController();
  final TextEditingController _productUsageSpeciesController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  String? _selectedCategoryId;
  String? _selectedCategoryName;
  List<DropdownMenuItem<String>> _categoryItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('categories').get();
      List<DropdownMenuItem<String>> items = snapshot.docs.map((doc) {
        return DropdownMenuItem(
          value: doc.id,
          child: Text(doc['name']),
        );
      }).toList();

      setState(() {
        _categoryItems = items;
      });

      if (_categoryItems.isEmpty) {
        print('No categories found.');
      } else {
        print('Categories fetched successfully.');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _uploadProduct() async {
    if (_productNameController.text.isEmpty ||
        _productDescriptionController.text.isEmpty ||
        _productPriceController.text.isEmpty ||
        _productStatusController.text.isEmpty ||
        _productUsageSpeciesController.text.isEmpty ||
        _image == null ||
        _selectedCategoryId == null) {
      _showSnackBar('All fields are required');
      return;
    }

    _showLoadingDialog();

    String imageUrl = '';

    try {
      if (_image != null) {
        TaskSnapshot uploadTask = await FirebaseStorage.instance
            .ref()
            .child('product_images/${_image!.path.split('/').last}')
            .putFile(_image!);
        imageUrl = await uploadTask.ref.getDownloadURL();
      }

      DocumentReference newProductRef = _firestore
          .collection('categories')
          .doc(_selectedCategoryId)
          .collection('items')
          .doc();

      await newProductRef.set({
        'category': _selectedCategoryName,
        'categoryId': _selectedCategoryId,
        'description': _productDescriptionController.text,
        'id': newProductRef.id,
        'image': imageUrl,
        'name': _productNameController.text,
        'price': double.parse(_productPriceController.text),
        'status': _productStatusController.text,
        'usageSpecies': _productUsageSpeciesController.text,
      });

      _productNameController.clear();
      _productDescriptionController.clear();
      _productPriceController.clear();
      _productStatusController.clear();
      _productUsageSpeciesController.clear();
      setState(() {
        _image = null;
        _selectedCategoryId = null;
        _selectedCategoryName = null;
      });

      Navigator.pop(context); 
      _showSuccessDialog();
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar('Failed to add product: $e');
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Adding product...'),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Product Added Successfully'),
          content: Text('The product has been added successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoriesPage()),
                );
              },
              child: Text('View'),
            ),
          ],
        );
      },
    );
  }

  String _getCategoryNameById(String id) {
    try {
      return _categoryItems.firstWhere((item) => item.value == id).child.toString();
    } catch (e) {
      print('Error getting category name by id: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 40),
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      BigText(
                        text: 'Add Products',
                        color: Colors.white, fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0XFFccc7c5), width: 5),
              ),
              child: GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: _image != null
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.image,
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Category'),
                value: _selectedCategoryId,
                items: _categoryItems,
                onChanged: (value) async {
                  if (value != null) {
                    setState(() {
                      _selectedCategoryId = value;
                      _selectedCategoryName = _getCategoryNameById(value);
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _productDescriptionController,
                decoration: InputDecoration(labelText: 'Product Description'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _productPriceController,
                decoration: InputDecoration(labelText: 'Product Price'),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _productStatusController,
                decoration: InputDecoration(labelText: 'Product Status'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _productUsageSpeciesController,
                decoration: InputDecoration(labelText: 'Usage Species'),
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: _uploadProduct,
                child: Text('Add Product', style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


