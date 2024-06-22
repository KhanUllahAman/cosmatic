import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseStorageHelper{

  static FirebaseStorageHelper firebaseStorageHelper = FirebaseStorageHelper();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;


  Future<String> uploadUserImage(File image)async{
    String userId  = FirebaseAuth.instance.currentUser!.uid;
    TaskSnapshot taskSnapshot =_firebaseStorage.ref(userId).putFile(image).snapshot;
    String imageUrl =  await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
    

  }

}