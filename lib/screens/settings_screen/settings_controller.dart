import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mayfair/data/model/app_model.dart';
import 'package:mayfair/data/service/api_client.dart';

class SettingsController extends GetxController {


  final currentPasswordController = TextEditingController();
  final changepassController = TextEditingController();
  final confirmChangePassController = TextEditingController();

  RxBool currentPasswordObscure = true.obs;
  RxBool newPasswordObscure = true.obs;
  RxBool confirmNewPasswordObscure = true.obs;

  final api = Get.find<ApiClient>();
  final userdata = Get.find<AppModel>().userModel;
  RxBool isLoading = false.obs;

  validateData() {
    if (currentPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Enter current password first");
    } else if (changepassController.text.isEmpty) {
      Get.snackbar("Error", "Enter new password");
    } else if (confirmChangePassController.text.isEmpty) {
      Get.snackbar("Error", "Enter confirmation password");
    } else if (confirmChangePassController.text != changepassController.text) {
      Get.snackbar("Error", "New password do not match");
    } else {
      changePassword();
    }
  }

  changePassword() async {
    try {
      isLoading = true.obs;
      update();
      await api.changePassword({
        'current_password': currentPasswordController.text,
        "new_password": changepassController.text,
        "user_id": userdata!.value!.data!.userId
      });
      currentPasswordController.clear();
      changepassController.clear();
      confirmChangePassController.clear();
      isLoading = false.obs;
      update();
    } on DioError catch (e) {
      isLoading = false.obs;
      update();
    }
  }
}
