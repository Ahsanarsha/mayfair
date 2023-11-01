import 'package:get/get.dart';
import 'package:mayfair/data/base/base_repo.dart';
import 'package:mayfair/data/model/UserModel.dart';

abstract class LoginRepo extends BaseRepo {
  Future<UserModel?>login({required Map<String,dynamic> data});
}