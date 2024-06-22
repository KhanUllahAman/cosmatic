import 'package:cosmatic/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageCategories extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _editCategoryNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        onPressed: () async {
          if (_categoryNameController.text.isNotEmpty) {
            var existingCategory = await _firestore
                .collection('categories')
                .where('name', isEqualTo: _categoryNameController.text)
                .get();

            if (existingCategory.docs.isNotEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Duplicate Category'),
                    content: Text('This category already exists. Please enter a new category name.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else {
              await _firestore.collection('categories').add({'name': _categoryNameController.text});
              _categoryNameController.clear();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Success'),
                    content: Text('Category added successfully'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
         iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColor.primaryColor,
        title: Text('Manage Categories', style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _categoryNameController,
              decoration: InputDecoration(labelText: 'Enter Category Name'),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('categories').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var categories = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    var category = categories[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                      child: Dismissible(
                        key: Key(category.id),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm'),
                                content: Text('Do you want to delete this item?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text('Yes'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          _firestore.collection('categories').doc(category.id).delete();
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.0),
                          color: Colors.red,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              category['name'],
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                _editCategoryNameController.text = category['name'];
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Edit Category'),
                                      content: TextField(
                                        controller: _editCategoryNameController,
                                        decoration: InputDecoration(labelText: 'Enter New Category Name'),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (_editCategoryNameController.text.isNotEmpty) {
                                              var existingCategory = await _firestore
                                                  .collection('categories')
                                                  .where('name', isEqualTo: _editCategoryNameController.text)
                                                  .get();

                                              if (existingCategory.docs.isNotEmpty) {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('Duplicate Category'),
                                                      content: Text('This category already exists. Please enter a new category name.'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                await _firestore.collection('categories').doc(category.id).update({'name': _editCategoryNameController.text});
                                                Navigator.of(context).pop();
                                              }
                                            }
                                          },
                                          child: Text('Yes'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



