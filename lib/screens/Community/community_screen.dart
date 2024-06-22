import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();
  List<DocumentSnapshot> _messages = [];
  bool _isLoading = true;
  String? _replyingToMessageId;

  void _postMessage() async {
    if (_messageController.text.isEmpty) return;
    final user = FirebaseAuth.instance.currentUser;
    final message = _messageController.text;
    final timestamp = FieldValue.serverTimestamp();

    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'userEmail': user!.email,
        'message': message,
        'timestamp': timestamp,
        'verified': false,
      });
      showMessage("Your message is pending admin approval");
      _messageController.clear();
    } catch (e) {
      showMessage('Error: $e');
    }
  }

  void _postReply(String messageId) async {
    if (_replyController.text.isEmpty) return;
    final user = FirebaseAuth.instance.currentUser;
    final reply = _replyController.text;
    final timestamp = FieldValue.serverTimestamp();

    try {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(messageId)
          .collection('replies')
          .add({
        'userEmail': user!.email,
        'reply': reply,
        'timestamp': timestamp,
      });

      showMessage("Reply added");
      _replyController.clear();
      setState(() {
        _replyingToMessageId = null;
      });
    } catch (e) {
      showMessage('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    FirebaseFirestore.instance
        .collection('messages')
        .where('verified', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _messages = snapshot.docs;
        _isLoading = false;
      });
    });
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown time';
    final DateTime dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat('yMMMd').add_jm();
    return formatter.format(dateTime);
  }

  void _showReplyDialog(String messageId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reply'),
          content: TextField(
            controller: _replyController,
            decoration: InputDecoration(
              labelText: 'Enter your reply',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _replyController.clear();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _postReply(messageId);
                Navigator.of(context).pop();
              },
              child: const Text('Reply'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot message) {
    final messageTime = _formatTimestamp(message['timestamp'] as Timestamp?);
    return Card(
      color: const Color.fromARGB(255, 247, 194, 212),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              message['message'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('By: ${message['userEmail']}'),
            trailing: Text(
              messageTime,
              style: const TextStyle(color: Colors.black),
            ),
            onLongPress: () {
              setState(() {
                _replyingToMessageId = message.id;
              });
              _showReplyDialog(message.id);
            },
          ),
          _buildReplies(message.id),
        ],
      ),
    );
  }

  Widget _buildReplies(String messageId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .doc(messageId)
          .collection('replies')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final replies = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: replies.length,
          itemBuilder: (context, index) {
            final reply = replies[index];
            final replyTime =
                _formatTimestamp(reply['timestamp'] as Timestamp?);
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 10, bottom: 5),
              child: Card(
                color: const Color.fromARGB(255, 255, 239, 246),
                child: ListTile(
                  title: Text(reply['reply']),
                  subtitle: Text('By: ${reply['userEmail']}'),
                  trailing: Text(
                    replyTime,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.primaryColor),
          title: Text(
        'Community',
        style: TextStyle(color: AppColor.primaryColor),
      ),
      centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageItem(message);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Enter your message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _postMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
