import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mayfair/data/model/GetNotificationModel.dart';
import 'package:mayfair/export.dart';
import 'package:mayfair/utills/utills.dart';
import 'package:mayfair/widgets/cache_image.dart';

import '../../widgets/app_bar_with_title.dart';
import 'notification_controller.dart';

class NotificationScreen extends GetView<NotificationController> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.off(() => Homepage(), binding: Appbindings());
        return Future.value(true);
      },
      child: GetBuilder<NotificationController>(builder: (_) {
        return Scaffold(
          key: _scaffoldKey,
          appBar:
              AppBarWithTitle("Notifications", true, scaffoldKey: _scaffoldKey),
          drawerScrimColor: appColors.transparent,
          body: Column(
            children: [
              controller.isLoading.isTrue
                  ? Container(
                      height: getScreenHeight(context) - 120,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      ),
                    )
                  : getNotificationList(context),
            ],
          ),
        );
      }),
    );
  }

  Widget getNotificationList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            )),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 100,
        child: ListView.builder(
          shrinkWrap: true,
            itemCount: controller
                .getNotificationModel!.value!.data!.notifications!.length,
            itemBuilder: (BuildContext context, int index) {
              return _myNotificationWidget(
                  controller
                      .getNotificationModel!.value!.data!.notifications![index],
                  context,
                  index);
            }),
      ),
    );
  }

  Widget _myNotificationWidget(
      Notifications notification, BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: index == 0 ? 15 : 0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CacheImage(
                      link: notification.user!.profilePhotoPath ??
                          controller.defaultImage,
                      name: notification.user!.firstname!),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Text(
                      notification.title!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Text(
                DateFormat("EEE dd MMM")
                    .format(DateTime.parse(notification.createdAt!)),
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Container(
                width: getScreenWidth(context) * 0.65,
                child: Text(
                  notification.body!,
                  textAlign: TextAlign.start,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 0).copyWith(top: 10),
            child: Divider(
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }
}
