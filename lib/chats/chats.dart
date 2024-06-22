// import 'package:cosmatic/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';


// class ChatScreen extends StatefulWidget {
//   final String chatId;
//   final bool isAdmin;
//   ChatScreen({required this.chatId, this.isAdmin = false});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   TextEditingController _messageController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   User? _currentUser;

//   @override
//   void initState() {
//     super.initState();
//     _currentUser = widget.isAdmin ? null : _auth.currentUser;
//     if (_currentUser == null && !widget.isAdmin) {
//     }
//   }

//   void _sendMessage() async {
//     if (_messageController.text.isNotEmpty && (_currentUser != null || widget.isAdmin)) {
//       await FirebaseFirestore.instance
//           .collection('chats')
//           .doc(widget.chatId)
//           .collection('messages')
//           .add({
//         'senderId': widget.isAdmin ? 'admin' : _currentUser!.uid,
//         'message': _messageController.text,
//         'email': _currentUser?.email ?? 'admin@domain.com',
//         'timestamp': Timestamp.now(),
//       });
//       await FirebaseFirestore.instance.collection('chats').doc(widget.chatId).set({
//         'lastMessage': _messageController.text,
//         'lastSenderEmail': _currentUser?.email ?? 'admin@domain.com',
//         'timestamp': Timestamp.now(),
//       }, SetOptions(merge: true));
//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_currentUser == null && !widget.isAdmin) {
//       return Scaffold(
//         body: Center(
//           child: Text('User not signed in'),
//         ),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('chats')
//                   .doc(widget.chatId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 var messages = snapshot.data!.docs.map((doc) {
//                   return ChatMessage.fromDocument(doc);
//                 }).toList();
//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     var message = messages[index];
//                     bool isMe = message.senderId == (_currentUser?.uid ?? 'admin');
//                     return _buildMessageTile(message, isMe);
//                   },
//                 );
//               },
//             ),
//           ),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageTile(ChatMessage message, bool isMe) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//         padding: EdgeInsets.all(10.0),
//         decoration: BoxDecoration(
//           color: isMe ? AppColor.primaryColor.withOpacity(0.5) : AppColor.primaryColor.withOpacity(0.5),
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               message.message,
//               style: TextStyle(color: Colors.black),
//             ),
//             SizedBox(height: 5.0),
//             Text(
//               message.senderId == 'admin' ? 'Admin' : 'User',
//               style: TextStyle(fontSize: 10.0, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageInput() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: InputDecoration(
//                 hintText: 'Enter message...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[100],
//               ),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.send),color: Colors.black,
//             onPressed: _sendMessage,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChatMessage {
//   final String senderId;
//   final String message;
//   final Timestamp timestamp;

//   ChatMessage({required this.senderId, required this.message, required this.timestamp});

//   factory ChatMessage.fromDocument(DocumentSnapshot doc) {
//     return ChatMessage(
//       senderId: doc['senderId'],
//       message: doc['message'],
//       timestamp: doc['timestamp'],
//     );
//   }
// }



import 'package:cosmatic/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final bool isAdmin;
  ChatScreen({required this.chatId, this.isAdmin = false});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentUser = widget.isAdmin ? null : _auth.currentUser;
    if (_currentUser == null && !widget.isAdmin) {
      // Handle unauthenticated state
    }
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty &&
        (_currentUser != null || widget.isAdmin)) {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'senderId': widget.isAdmin ? 'admin' : _currentUser!.uid,
        'message': _messageController.text,
        'email': _currentUser?.email ?? 'admin@domain.com',
        'timestamp': Timestamp.now(),
      });
      await FirebaseFirestore.instance.collection('chats').doc(widget.chatId).set({
        'lastMessage': _messageController.text,
        'lastSenderEmail': _currentUser?.email ?? 'admin@domain.com',
        'timestamp': Timestamp.now(),
      }, SetOptions(merge: true));
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null && !widget.isAdmin) {
      return Scaffold(
        body: Center(
          child: Text('User not signed in'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(widget.chatId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var messages = snapshot.data!.docs.map((doc) {
                    return ChatMessage.fromDocument(doc);
                  }).toList();
                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      bool isMe = message.senderId == (_currentUser?.uid ?? 'admin');
                      return _buildMessageTile(message, isMe);
                    },
                  );
                },
              ),
            ),
            _buildMessageInput(context),
          ],
       
      ),
    )
    );
  }

  Widget _buildMessageTile(ChatMessage message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isMe ? AppColor.primaryColor.withOpacity(0.5) : AppColor.primaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 5.0),
            Text(
              message.senderId == 'admin' ? 'Admin' : 'User',
              style: TextStyle(fontSize: 10.0, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 8.0,
            left: 8.0,
            right: 8.0,
            top: 8.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Enter message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onTap: _scrollToBottom,
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.black),
                onPressed: _sendMessage,
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChatMessage {
  final String senderId;
  final String message;
  final Timestamp timestamp;

  ChatMessage({required this.senderId, required this.message, required this.timestamp});

  factory ChatMessage.fromDocument(DocumentSnapshot doc) {
    return ChatMessage(
      senderId: doc['senderId'],
      message: doc['message'],
      timestamp: doc['timestamp'],
    );
  }
}

