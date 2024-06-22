import 'package:cosmatic/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class VerifyAccounts extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> verifyAccount(String userId) async {
    await _firestore.collection('users').doc(userId).update({'verified': true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColor.primaryColor,
        title: Text('Verify Accounts', style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              var userData = user.data() as Map<String, dynamic>;
              bool isVerified =  userData.containsKey('verified') && userData['verified'] == true;
              return ListTile(
                title: Text(userData['email']),
                subtitle: Text('Name: ${userData['name']}'),
                trailing: isVerified
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Text('Approved', style: TextStyle(color: Colors.white)),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          await verifyAccount(user.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User ${userData['name']} verified successfully')),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(AppColor.primaryColor),
                        ),
                        child: Text('Verify', style: TextStyle(color: Colors.white),),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}