import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCommunity extends StatefulWidget {
  const AdminCommunity({Key? key}) : super(key: key);

  @override
  State<AdminCommunity> createState() => _AdminCommunityState();
}

class _AdminCommunityState extends State<AdminCommunity> {
  void _approveMessage(String messageId) async {
    try {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(messageId)
          .update({'verified': true});

      showMessage("Message approved");
    } catch (e) {
      showMessage('Error: $e');
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColor.primaryColor,
        title: Text('Admin Community', style: TextStyle(color: Colors.white),),
        ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No messages to display'));
          } else {
            final messages = snapshot.data!.docs;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final bool isVerified = message['verified'] ?? false;
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ListTile(
                    title: Text(
                      message['message'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('By: ${message['userEmail']}'),
                    trailing: isVerified
                        ? null
                        : IconButton(
                            icon: Icon(Icons.check, color: Colors.green),
                            onPressed: () => _approveMessage(message.id),
                          ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
