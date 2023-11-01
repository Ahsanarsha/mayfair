import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mayfair/res/export.dart';

import '../di/init_controller.dart';
import '../screens/home_screen/homepage.dart';

class AppBarWithTitle extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  bool isBack;
  String title;
  bool? showRefresh;
  Function()? onPressed;
  AppBarWithTitle(this.title, this.isBack,
      {Key? key, required this.scaffoldKey, this.showRefresh,this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: appColors.appBarColor,
      leading: isBack
          ? IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back, color: appColors.black),
            )
          : IconButton(
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
              icon: Icon(Icons.menu, color: appColors.black),
            ),
      actions: [
        if (showRefresh != null)
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.refresh,
              color: appColors.black,
              size: 18,
            ),
          )
      ]
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
}
