import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mayfair/data/model/UserModel.dart';
import 'package:mayfair/data/model/UserProfileModel.dart';
import 'package:mayfair/data/model/app_model.dart';
import 'package:mayfair/data/service/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../export.dart';
import '../../main.dart';

class SplashController extends GetxController {
  final api = Get.find<ApiClient>();
  final user_key = "user_data";

  @override
  void onInit() {
    super.onInit();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
              ),
            ));
      }
    });

    getFCMToken();
  }

  getFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    //log'Device Token${token!}');
  }

  Future<bool> checkLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.containsKey(user_key);
  }

  Future<UserData?> getUserFromSp() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return UserData.fromJson(json.decode(pref.getString(user_key)!));
  }

  Future<void> setAlreadyLoggedIn() async {
    UserData? mData = await getUserFromSp();
    if (mData != null) {
      log("${mData.token}");
      log("${mData.userId}");
      log("${mData.name}");
      log("${mData.email}");
      log("${mData.image}");

      try {
        if (constants.connectionStatus.hasConnection){
          AppModel userdata = Get.find();
          AppModel profileData = Get.find();
          userdata.userModel =
              UserModel(data: mData, message: "", success: true).obs;
          Rx<UserProfileModel?> profilemodel =
              (await api.userProfile(id: mData.userId.toString())).obs;
          profileData.userProfileModel = profilemodel;
          GetStorage()
              .write('token', userdata.userModel!.value!.data!.token!.toString());
          Get.offAll(() => Homepage());
        }else{
          Get.defaultDialog(
              title: "No Internet",
              middleText: "Please check your internet connection",
              textConfirm: "Ok",
              onConfirm: () async{
                if(constants.connectionStatus.hasConnection) {
                  Get.back();
                  try{
                    AppModel userdata = Get.find();
                    AppModel profileData = Get.find();
                    userdata.userModel =
                        UserModel(data: mData, message: "", success: true).obs;
                    Rx<UserProfileModel?> profilemodel =
                        (await api.userProfile(id: mData.userId.toString())).obs;
                    profileData.userProfileModel = profilemodel;
                    GetStorage()
                        .write('token', userdata.userModel!.value!.data!.token!.toString());
                    Get.offAll(() => Homepage());
                  }catch (e) {
                    await removeUserFromSp();
                    Get.off(() => LoginScreen(), binding: Appbindings());
                  }
                }
              });
        }

      } catch (e) {
        await removeUserFromSp();
        Get.off(() => LoginScreen(), binding: Appbindings());
      }
    }
  }

  Future<void> removeUserFromSp()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(user_key);
  }
}
