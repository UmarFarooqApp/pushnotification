import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:local_services/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> addUserProfileImageToStorage(
      {required File profileUrl}) async {
    try {
      var downloadUrl;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? uid = sharedPreferences.getString("uid");
      var snapshot = await _firebaseStorage
          .ref()
          .child("users/profilePictures/$uid")
          .putFile(profileUrl);
      downloadUrl = snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log("********* Exception In: addProfileImageToStorage from catch  *********");
      log(e.toString());
      Util.showErrorSnackBar(e.toString());
      return "";
    }
  }

  Future<String> addServicesImageToStorage(
      {required File imageUrl, required String userId}) async {
    File file = File(imageUrl.path); // Replace with the path to your image file
    Uint8List imageUrl1 = await file.readAsBytes();
    try {
      UploadTask uploadTask;
      var downloadUrl;


      Reference snapshot = (await _firebaseStorage
          .ref()
          .child("services/images/$userId")
          .putFile(imageUrl)) as Reference;
      uploadTask = snapshot.putData(imageUrl1);
      await uploadTask.whenComplete(() => null);
      downloadUrl = snapshot.getDownloadURL();// change done here
      return downloadUrl;
    } catch (e) {
      log("********* Exception In: addProfileImageToStorage from catch  *********");
      log(e.toString());
      Util.showErrorSnackBar(e.toString());
      return "";
    }
  }
}
