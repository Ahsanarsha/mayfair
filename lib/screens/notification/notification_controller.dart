import 'dart:developer';

import 'package:get/get.dart';
import 'package:mayfair/data/model/GetNotificationModel.dart';
import 'package:mayfair/data/service/api_client.dart';

class NotificationController extends GetxController {

  final api = Get.find<ApiClient>();
  RxBool isLoading = false.obs;

  String defaultImage="https://i.postimg.cc/kg1yzFyb/User.jpg";

  Rx<GetNotificationModel?>? getNotificationModel;

  @override
  void onInit() {
    getNotification();
  }

  getNotification() async {
    //log"Notification API CAll");
    isLoading = true.obs;
    getNotificationModel = (await api.getNotificationApi()).obs;
    isLoading = false.obs;
    update();
  }
}
