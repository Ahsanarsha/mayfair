import 'package:get/get.dart';

import 'package:mayfair/data/model/app_model.dart';
import 'package:mayfair/data/repo/dashboard/dashboard_repo.dart';
import 'package:mayfair/data/repo/dashboard/dashboard_repo_imp.dart';
import 'package:mayfair/data/repo/login/login_repo.dart';
import 'package:mayfair/data/repo/login/login_repo_imp.dart';
import 'package:mayfair/data/service/api_client.dart';
import 'package:mayfair/export.dart';
import 'package:mayfair/screens/notification/export.dart';

import '../screens/travel_approval_screen/travel_approval_screen_controller.dart';


class Appbindings extends Bindings{
  @override
  void dependencies() {

    Get.lazyPut(() => SplashController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => AppModel());
    Get.lazyPut<DashBoardRepo>(() => DashBoardRepoImpl());
    Get.lazyPut<LoginRepo>(() => LoginRepoImp());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ApprovalsController());
    Get.lazyPut(() => TravelApprovalsController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => SettingsController());
    Get.lazyPut(() => TravelExpensesCalenderController());
    Get.lazyPut(() => HeadQuarterExpensesCalenderController());
    Get.lazyPut(() => TravelExpensesWRTDateController());
    Get.lazyPut(() => ExpensesPerDayController());
    Get.lazyPut(() => NotificationController());

  }

}