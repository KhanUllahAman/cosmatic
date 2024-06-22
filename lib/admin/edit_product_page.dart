import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProductPage extends StatefulWidget {
  final DocumentSnapshot productDoc;
  final String categoryId;

  EditProductPage({required this.productDoc, required this.categoryId});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _statusController;
  late TextEditingController _usageSpeciesController;
  String? _selectedCategory;
  String? _imageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productDoc['name']);
    _descriptionController = TextEditingController(text: widget.productDoc['description']);
    _priceController = TextEditingController(text: widget.productDoc['price'].toString());
    _statusController = TextEditingController(text: widget.productDoc['status']);
    _usageSpeciesController = TextEditingController(text: widget.productDoc['usageSpecies']);
    _selectedCategory = widget.categoryId;
    _imageUrl = widget.productDoc['image'];
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
              Text('Updating product...'),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _imageUrl = null;
      }
    });
  }
  void _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      _showLoadingDialog();
      String imageUrl = _imageUrl ?? widget.productDoc['image'];
      if (_imageFile != null) {

      }

      await _firestore
          .collection('categories')
          .doc(_selectedCategory)
          .collection('items')
          .doc(widget.productDoc.id)
          .update({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'image': imageUrl,
        'status': _statusController.text,
        'usageSpecies': _usageSpeciesController.text,
      });

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Your product was edited successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); 
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _statusController.dispose();
    _usageSpeciesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColor.primaryColor,
        title: Text('Edit Product', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image.file(
                    _imageFile!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
              else if (_imageUrl != null && _imageUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image.network(
                    _imageUrl!,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Failed to load image');
                    },
                  ),
                ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Select Image', style: TextStyle(color: Colors.white),),
              ),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
              ),
              TextFormField(
                controller: _usageSpeciesController,
                decoration: InputDecoration(labelText: 'Usage Species'),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateProduct,
                  child: Text('Save Changes', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
