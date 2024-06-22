import 'package:cosmatic/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class AdminVerificationScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _verifyVideo(String docId) async {
    await _firestore.collection('myvideo').doc(docId).update({'isVerified': true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColor.primaryColor,
        title: Text('Verify Videos', style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('myvideo').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot video = snapshot.data!.docs[index];
              return AdminVideoPlayerScreen(video: video, onVerify: _verifyVideo);
            },
          );
        },
      ),
    );
  }
}

class AdminVideoPlayerScreen extends StatefulWidget {
  final DocumentSnapshot video;
  final Future<void> Function(String docId) onVerify;

  AdminVideoPlayerScreen({required this.video, required this.onVerify});

  @override
  _AdminVideoPlayerScreenState createState() => _AdminVideoPlayerScreenState();
}

class _AdminVideoPlayerScreenState extends State<AdminVideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video['url'])
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _approveVideo() async {
    await widget.onVerify(widget.video.id);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('The video has been approved.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isVerified = widget.video['isVerified'];

    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPlaying ? _controller.pause() : _controller.play();
                        _isPlaying = !_isPlaying;
                      });
                    },
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton(
                      onPressed: isVerified ? null : _approveVideo,
                      backgroundColor: isVerified ? Colors.grey : AppColor.primaryColor,
                      child: Icon(isVerified ? Icons.check : Icons.check),
                    ),
                  ),
                  if (!isVerified && !_isPlaying)
                    Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 100.0,
                      ),
                    ),
                  if (isVerified)
                    Positioned(
                      bottom: 80,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.black54,
                        child: Text(
                          'This video is approved',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
