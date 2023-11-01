import 'package:mayfair/data/model/UserModel.dart';
import 'login_repo.dart';

class LoginRepoImp extends LoginRepo {
  @override
  Future<UserModel?>login({required Map<String , dynamic> data}) {
    return apiClient.login(data);
  }
}
