import 'package:cosmatic/chats/chats.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardChats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('An error occurred, please try again later'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No chats available'));
          }

          var chatDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              var chatDoc = chatDocs[index];
              var chatId = chatDoc.id;
              var data = chatDoc.data() as Map<String, dynamic>;
              return _buildChatTile(context, chatId, data);
            },
          );
        },
      ),
    );
  }

  Widget _buildChatTile(BuildContext context, String chatId, Map<String, dynamic> data) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminChatScreen(chatId: chatId),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: AppColor.primaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColor.primaryColor,
              child: Text(
                data['lastSenderEmail'] != null && data['lastSenderEmail'].isNotEmpty
                    ? data['lastSenderEmail'][0].toUpperCase()
                    : 'U',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['lastSenderEmail'] ?? 'Unknown',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    data['lastMessage'] ?? 'No messages yet',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}



class AdminChatScreen extends StatelessWidget {
  final String chatId;
  AdminChatScreen({required this.chatId});

  @override
  Widget build(BuildContext context) {
    return ChatScreen(chatId: chatId, isAdmin: true);
  }
}