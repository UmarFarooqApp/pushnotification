import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_services/config/firebase_storage.dart';
import 'package:local_services/config/firestore.dart';
import 'package:local_services/controllers/language_controller.dart';
import 'package:local_services/model/user_model.dart';
import 'package:local_services/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController implements GetxService {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Rxn<UserModel> user = Rxn<UserModel>();
  RxBool isLoading = true.obs;

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? userInfo = userCredential.user;
      if (userInfo == null) {
        log("Here login");
        sharedPreferences.setString("uid", "");

        return false;
      } else {
        sharedPreferences.setString("uid", userInfo.uid);

        return true;
      }
    } on FirebaseAuthException catch (e) {
      log("********* Exception In: signInWithEmailAndPassword  *********");
      Util.checkFirebaseException(e.code.toString());
      log(e.code.toString());
      return false;
    } catch (e) {
      log("********* Exception In: signInWithEmailAndPassword  *********");
      log(e.toString());
      Util.showErrorSnackBar(e.toString());
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      UserModel userModel = UserModel();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final User? user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      if (user == null) {
        // throw AppTexts.somethingWentWrong;
        log("Here login");
        sharedPreferences.setString("uid", "");

        return false;
      } else {
        userModel = userModel.copyWith(
            uid: auth.currentUser!.uid,
            email: user.email ?? "",
            phone: user.phoneNumber ?? "",
            language: "English",
            favoriteList: [],
            updatedAt: DateTime.now().toString(),
            createdAt: DateTime.now().toString(),
            profileUrl: user.photoURL ?? "");

        await FirestoreService().createUser(userModel: userModel);
        sharedPreferences.setString("uid", user.uid);

        return true;
      }
    } on FirebaseAuthException catch (e) {
      log("********* Exception In: signInWithGoogle  *********");
      Util.checkFirebaseException(e.code.toString());
      log(e.code.toString());
      return false;
    } catch (e) {
      log("********* Exception In: signInWithGoogle  *********");
      log(e.toString());
      Util.showErrorSnackBar(e.toString());
      return false;
    }
  }

  Future<dynamic> registerWithEmailAndPassword({
    required UserModel userModel,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: userModel.email!, password: password);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      User? user = userCredential.user;
      if (user == null) {
        // throw AppTexts.somethingWentWrong;
      } else {
        userModel = userModel.copyWith(
            uid: auth.currentUser!.uid,
            email: userModel.email,
            phone: userModel.phone,
            language: userModel.language,
            favoriteList: [],
            updatedAt: DateTime.now().toString(),
            createdAt: DateTime.now().toString(),
            profileUrl: "");
        //Todo Check UserController save value of this User.
        bool temp = await FirestoreService().createUser(userModel: userModel);
        if (temp) {
          sharedPreferences.setString("uid", userModel.uid ?? "");
          sharedPreferences.setString(
              "language", userModel.language.toString().toLowerCase());
          Get.find<LanguageController>()
              .updateLanguage(userModel.language.toString().toLowerCase());

          return true;
        } else {
          sharedPreferences.setString("uid", "");
          sharedPreferences.setString("language", "english");
          Get.find<LanguageController>().updateLanguage("english");

          return false;
        }
      }
    } on FirebaseAuthException catch (e) {
      log("********* Exception In: registerWithEmailAndPassword from FB  *********");
      log(e.toString());
      Util.checkFirebaseException(e.code);
      return false;
    } catch (e) {
      log("********* Exception In: registerWithEmailAndPassword from catch  *********");
      log(e.toString());
      Util.showErrorSnackBar(e.toString());
      return false;
    }
  }

  Future<dynamic> updateUserAccount(
      {required UserModel userModel, required File? profileUrl}) async {
    try {
      String profileUrlData = "";
      if (profileUrl != null) {
        profileUrlData = await FirebaseStorageService()
            .addUserProfileImageToStorage(profileUrl: profileUrl);
      }

      if (profileUrlData != "") {
        userModel = userModel.copyWith(
          uid: auth.currentUser!.uid,
          email: auth.currentUser!.email,
          phone: userModel.phone,
          language: user.value?.language,
          favoriteList: user.value?.favoriteList,
          profileUrl: profileUrl != null ? profileUrlData : "",
          updatedAt: DateTime.now().toString(),
          createdAt: user.value?.createdAt,
        );
        //Todo Check UserController save value of this User.
        await FirestoreService().updateUser(userModel: userModel);
      } else {
        userModel = userModel.copyWith(
          uid: auth.currentUser!.uid,
          email: auth.currentUser!.email,
          phone: userModel.phone,
          language: user.value?.language,
          favoriteList: user.value?.favoriteList,
          profileUrl: "",
          updatedAt: DateTime.now().toString(),
          createdAt: user.value?.createdAt,
        );
        //Todo Check UserController save value of this User.
        await FirestoreService().updateUser(userModel: userModel);
        log("Error in uploading image");
      }
    } on FirebaseAuthException catch (e) {
      log("********* Exception In: updateAccout from FB  *********");
      log(e.toString());
      Util.checkFirebaseException(e.code);
      return false;
    } catch (e) {
      log("********* Exception In: updateAccout from catch  *********");
      log(e.toString());
      Util.showErrorSnackBar(e.toString());
      return false;
    }
  }

  Future<bool> updateUserLanguage(String language) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? uid = sharedPreferences.getString("uid");
      bool result = await FirestoreService()
          .updateLanguageOfUser(language: language, uid: uid ?? "");
      if (result == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? uid = sharedPreferences.getString("uid");
    log(uid.toString());
    return await FirestoreService().getUser(uid ?? "").then((userData) async {
      log("1 ${userData.toString()}");
      if (userData == null) {
        log("2 ${userData.toString()}");

        return false;
      } else {
        log("3 ${userData.toString()}");

        user.value = userData;
        update();
        return true;
      }
    });
  }

  Future<bool> resetPasword({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      Util.showErrorSnackBar("Reset Link Sent Successfully");
      return true;
    } on FirebaseAuthException catch (e) {
      log("********* Exception In: registerWithEmailAndPassword from FB  *********");
      log(e.toString());
      Util.checkFirebaseException(e.code);
      return false;
    } catch (e) {
      log("********* Exception In: registerWithEmailAndPassword from catch  *********");
      log(e.toString());
      Util.showErrorSnackBar(e.toString());
      return false;
    }
  }

  void loadPage(bool value) {
    isLoading.value = value;
    update();
  }
}
