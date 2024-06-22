import 'package:cosmatic/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class ManageUploadedContent extends StatefulWidget {
  @override
  _ManageUploadedContentState createState() => _ManageUploadedContentState();
}

class _ManageUploadedContentState extends State<ManageUploadedContent> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? _video;
  final picker = ImagePicker();
  VideoPlayerController? _videoController;
  bool _isUploading = false;

  Future<void> _pickVideo() async {
    final pickedFile = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(seconds: 34),
    );

    if (pickedFile != null) {
      final videoFile = File(pickedFile.path);

      // Check the duration of the video
      final videoPlayerController = VideoPlayerController.file(videoFile);
      await videoPlayerController.initialize();
      final videoDuration = videoPlayerController.value.duration;

      if (videoDuration.inSeconds < 5 || videoDuration.inSeconds > 35) {
        // Show error if the duration is not between 5 and 35 seconds
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select a video between 5 and 35 seconds long.'),
        ));
        return;
      }

      setState(() {
        _video = videoFile;
        _videoController = videoPlayerController;
      });

      _videoController!.setLooping(true);
      _videoController!.play();
    }
  }

  Future<void> _uploadVideo() async {
    if (_video == null) return;

    setState(() {
      _isUploading = true;
    });

    TaskSnapshot uploadTask = await _storage
        .ref()
        .child('uploads/${_video!.path.split('/').last}')
        .putFile(_video!);

    String videoUrl = await uploadTask.ref.getDownloadURL();

    await _firestore.collection('myvideo').add({
      'url': videoUrl,
      'uploaded_at': Timestamp.now(),
      'isVerified': false,
    });

    setState(() {
      _isUploading = false;
      _video = null;
      _videoController?.dispose();
      _videoController = null;
    });

    // Show a popup message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Your video has been uploaded and is pending verification.'),
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

    print('Uploaded Video URL: $videoUrl');
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          'Upload Cosmetic Reels',
          style: TextStyle(color: AppColor.primaryColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 130,),
              _video == null
                  ? Column(
                      children: [
                        Icon(
                          Icons.video_library,
                          color: Colors.grey,
                          size: 100.0,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Pick a video to upload',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: _videoController != null &&
                                _videoController!.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: _videoController!.value.aspectRatio,
                                child: VideoPlayer(_videoController!),
                              )
                            : Container(),
                      ),
                    ),
              SizedBox(height: 20.0),
              ElevatedButton.icon(
                onPressed: _pickVideo,
                icon: Icon(Icons.add_a_photo, color: Colors.white),
                label: Text(
                  'Pick Video',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _uploadVideo,
                icon: _isUploading
                    ? Container(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Icon(Icons.cloud_upload, color: Colors.white),
                label: _isUploading
                    ? Text(
                        'Uploading...',
                        style: TextStyle(color: Colors.white),
                      )
                    : Text(
                        'Upload Video',
                        style: TextStyle(color: Colors.white),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
