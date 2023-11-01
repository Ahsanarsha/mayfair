import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mayfair/data/model/UserModel.dart';
import 'package:mayfair/data/model/UserProfileModel.dart';
import 'package:mayfair/data/model/app_model.dart';
import 'package:mayfair/data/repo/login/login_repo.dart';
import 'package:mayfair/screens/home_screen/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/base/base_controller.dart';
import '../../data/model/FcmModel.dart';
import '../../data/service/api_client.dart';

class LoginController extends BaseController {
  final TextEditingController userEmail = TextEditingController();
  final TextEditingController userPassword = TextEditingController();
  LoginRepo repo = Get.find();
  final api = Get.find<ApiClient>();
  RxBool isLoading = false.obs;
  RxBool netConnection = true.obs;
  RxBool isObscurePass = true.obs;
  var token = "".obs;

  final user_key = "user_data";

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;



  checkInternet() {
    Connectivity _connectivity = Connectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        netConnection = true.obs;
        update();
      } else {
        netConnection = false.obs;
        update();
      }
    });
  }

  validateData() {
    if (!userEmail.text.trim().isEmail) {
      Get.snackbar("Error", "Email format is not valid");
    } else if (userEmail.text.isEmpty) {
      Get.snackbar("Error", "Email address can not be empty");
    } else if (userPassword.text.isEmpty) {
      Get.snackbar("Error", "Password can not be empty");
    } else {
      login();
      getFCMToken();
    }
  }

  Future<void> login() async {
    isLoading = true.obs;
    update();
    try {
      Rx<UserModel?> model = (await repo.login(data: {
        'email': userEmail.text.trim(),
        'password': userPassword.text.trim()
      }))
          .obs;
      try{
        await saveUserSession(model.value!.data);
      }catch(error){
        log(error.toString());
        isLoading = true.obs;
      }

      AppModel userdata = Get.find();
      AppModel profileData = Get.find();
      userdata.userModel = model;
      if (userdata.userModel!.value != null) {
        if (userdata.userModel!.value!.success!) {
          Rx<UserProfileModel?> profilemodel = (await api.userProfile(
                  id: userdata.userModel!.value!.data!.userId.toString()))
              .obs;
          profileData.userProfileModel = profilemodel;
          //print("PROFILE DATA ${profilemodel.value!.data}");
          GetStorage().write(
              'token', userdata.userModel!.value!.data!.token!.toString());
          //print(GetStorage().read('token'));

          Rx<FcmModel?> model =
              (await api.postFcmToken(token.value, userEmail.text.trim())).obs;

          Get.offAll(() => Homepage());
        }
      }
      isLoading = false.obs;
      update();
    } on DioError catch (e) {
      isLoading = false.obs;
      update();
    }
  }

  getFCMToken() async {
    token.value = (await FirebaseMessaging.instance.getToken())!;
    update();
    log('Device Token ${token.value}');
  }

  Future<void> saveUserSession(UserData? data) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(user_key, json.encode(data!.toJson()).toString());
  }
}
