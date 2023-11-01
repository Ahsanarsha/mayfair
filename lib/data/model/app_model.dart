import 'package:get/get.dart';
import 'package:mayfair/data/model/UserModel.dart';
import 'package:mayfair/data/model/UserProfileModel.dart';

class AppModel {
  Rx<UserModel?>? _userModel;
  Rx<UserProfileModel?>? _userProfileModel;


  Rx<UserProfileModel?>? get userProfileModel => _userProfileModel;

  set userProfileModel(Rx<UserProfileModel?>? value) {
    _userProfileModel = value;
  }

  Rx<UserModel?>? get userModel => _userModel;

  set userModel(Rx<UserModel?>? value) {
    _userModel = value;
  }
}
