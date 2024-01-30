import 'package:firebase_messaging/firebase_messaging.dart';

class NotinficationServices{
  static final fcm =FirebaseMessaging.instance;
  static Future init()async{
    fcm.requestPermission();
    final token=await fcm.getToken();
    print("fcm token is ${token}");
  }
}