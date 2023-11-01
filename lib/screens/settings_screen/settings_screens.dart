import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mayfair/export.dart';
import 'package:mayfair/widgets/app_bar_with_title.dart';

class SettingsScreen extends GetView<SettingsController> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.off(() => Homepage(), binding: Appbindings());
        return Future.value(true);
      },
      child: GetBuilder<SettingsController>(builder: (_) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBarWithTitle(
            "Setting",
            false,
            scaffoldKey: _scaffoldKey,
          ),
          drawer: CustomDrawer(),
          drawerScrimColor: appColors.transparent,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: 35.h,
                ),
                getChangePasswordHeading(),
                SizedBox(
                  height: 10.h,
                ),
                getChangePassword(context),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget getChangePassword(BuildContext context) {
    return Container(
      width: 384.w,
      height: MediaQuery.of(context).size.height * 0.45,
      color: const Color(0xFFF8F8F8),
      child: Column(
        children: [
          SizedBox(
            height: 40.h,
          ),
          Container(
            width: 355.w,
            height: 56.h,
            decoration: BoxDecoration(
                color: appColors.white,
                border: Border.all(
                  color: appColors.borderColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0)),
            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
            child: Row(
              children: [
                Expanded(
                  child: Obx(()=>TextFormField(
                    controller: controller.currentPasswordController,
                    obscureText: controller.currentPasswordObscure.value ? true : false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Current Password",
                        suffixIcon: IconButton(
                          color: Colors.red,
                          icon: Icon(
                            controller.currentPasswordObscure.isFalse
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            controller.currentPasswordObscure.value =
                            !controller.currentPasswordObscure.value;
                          },
                        )),
                  )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40.h,
          ),
          Container(
            width: 355.w,
            height: 56.h,
            decoration: BoxDecoration(
                color: appColors.white,
                border: Border.all(
                  color: appColors.borderColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0)),
            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
            child: Row(
              children: [
                Expanded(
                  child: Obx(()=>TextFormField(
                    controller: controller.changepassController,
                    obscureText: controller.newPasswordObscure.value ? true : false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter New Password",
                        suffixIcon: IconButton(
                          color: Colors.red,
                          icon: Icon(
                            controller.newPasswordObscure.isFalse
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            controller.newPasswordObscure.value =
                            !controller.newPasswordObscure.value;
                          },
                        )),
                  )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 34.h,
          ),
          Container(
            width: 355.w,
            height: 56.h,
            decoration: BoxDecoration(
                color: appColors.white,
                border: Border.all(
                  color: appColors.borderColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(2.0)),
            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
            child: Row(
              children: [

                Expanded(
                  child: Obx(()=>TextFormField(
                    controller: controller.confirmChangePassController,
                    obscureText: controller.confirmNewPasswordObscure.value ? true : false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Current Password",
                        suffixIcon: IconButton(
                          color: Colors.red,
                          icon: Icon(
                            controller.confirmNewPasswordObscure.isFalse
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            controller.confirmNewPasswordObscure.value =
                            !controller.confirmNewPasswordObscure.value;
                          },
                        )),
                  )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 33.h,
          ),
          Container(
            width: 355.w,
            height: 52.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              color: appColors.gradientColor1,
            ),
            child: TextButton(
              onPressed: () {
                controller.validateData();
              },
              style: TextButton.styleFrom(
                primary: appColors.white,
              ),
              child: Text("Update",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: appColors.white,
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget getChangePasswordHeading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 33.h),
      child: Container(
        width: double.infinity,
        child: Text(
          "Change Password",
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
