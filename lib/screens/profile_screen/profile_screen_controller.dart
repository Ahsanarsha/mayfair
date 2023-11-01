import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mayfair/data/model/UserProfileModel.dart';
import 'package:mayfair/data/model/app_model.dart';
import 'package:mayfair/data/service/api_client.dart';
import 'package:mayfair/export.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var userdata = Get.find<AppModel>().userProfileModel;
  final api = Get.find<ApiClient>();
  AppModel mUserdata = Get.find();
  RxBool _isLoading = false.obs;
  final user_key = "user_data";

  RxBool get isLoading => _isLoading;

  set isLoading(RxBool value) {
    _isLoading = value;
    update();
  }


  @override
  void onInit() {
    getProfile();
  }

  getProfile()async{
    isLoading = true.obs;

    userdata = (await api.userProfile(
    id: mUserdata.userModel!.value!.data!.userId.toString()))
    .obs;
    isLoading = false.obs;

  }

  getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      isLoading = true.obs;
      File file = File(image.path);
      await api.uploadImage(file);
      userdata = (await api.userProfile(
              id: mUserdata.userModel!.value!.data!.userId.toString()))
          .obs;
      update();
      isLoading = false.obs;
      //print("RESULT ${userdata!.value!.data!.profilePhotoPath}");
    }
  }

  logout() async {
    await api.logout().then((value) async{
      if (value) {
        await removeUserFromSp();
        Get.offAll(LoginScreen());
      }
    });
  }

  Future<void> removeUserFromSp()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(user_key);
  }
}
