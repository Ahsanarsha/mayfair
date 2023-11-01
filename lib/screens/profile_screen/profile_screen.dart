import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mayfair/data/base/base_url.dart';
import 'package:mayfair/export.dart';
import 'package:mayfair/widgets/app_bar_with_title.dart';

class ProfileScreen extends GetView<ProfileController> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    String joiningDate;
    try{
      joiningDate=controller.userdata!.value!.data!.joiningDate!;
    }catch(error){
      //logerror.toString());
      joiningDate="";
    }

    return WillPopScope(
      onWillPop: () {
        Get.off(() => Homepage(), binding: Appbindings());
        return Future.value(true);
      },
      child: GetBuilder<ProfileController>(
        builder: (_) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBarWithTitle("My Profile",false,scaffoldKey: _scaffoldKey),
            drawer: const CustomDrawer(),
            drawerScrimColor: appColors.transparent,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 320.h,
                        color: appColors.black,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 62.h,
                            ),
                            Center(
                              child: Stack(
                                children: [
                                  ClipOval(
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(45),
                                      child: Container(
                                        width: 130.w,
                                        height: 130.h,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: controller.isLoading.value
                                            ? const Center(
                                                child: SpinKitCircle(
                                                  color: Colors.white,
                                                ),
                                              )
                                            : controller.userdata!.value!.data!
                                                        .profilePhotoPath ==
                                                    null
                                                ? Image.asset(Assets().user)
                                                : Image.network(
                                                    BaseUrls.baseProfileUrl +
                                                        controller
                                                            .userdata!
                                                            .value!
                                                            .data!
                                                            .profilePhotoPath!,
                                                    fit: BoxFit.cover,
                                                  ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: controller.isLoading.value
                                        ? Container()
                                        :  IconButton(onPressed: (){
                                      controller.getImage();
                                    }, icon: Icon(Icons.edit),color: appColors.black,),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                "${controller.userdata!.value!.data!.firstname!} "
                                    "${controller.userdata!.value!.data!.lastname!}",
                                style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color: appColors.white),
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                "Member since $joiningDate",
                                style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color: appColors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 300.h,
                    left: 22.w,
                    right: 22.w,
                    child: Container(
                      decoration: BoxDecoration(
                          color: appColors.white,
                          borderRadius: BorderRadius.circular(2.0),
                          border: Border.all(
                              width: 0.2, color: appColors.borderColor)),
                      padding: EdgeInsets.symmetric(horizontal: 36.h),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40.h,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 105.w,
                                child: Text("Designation",
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                              SizedBox(
                                width: 47.h,
                              ),
                              Expanded(
                                child: Text(
                                    "${controller.userdata!.value!.data!.designation}",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    )),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 2,
                            color: appColors.dividerColor,
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 105.w,
                                child: Text("Contact Number",
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                              SizedBox(
                                width: 47.h,
                              ),
                              Text(
                                  "${controller.userdata!.value!.data!.phoneNumber}",
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ))
                            ],
                          ),
                          Divider(
                            thickness: 2,
                            color: appColors.dividerColor,
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 105.w,
                                child: Text("Line Manager",
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                              SizedBox(
                                width: 47.h,
                              ),
                              Text(
                                  controller.userdata!.value!.data!.lineManager!=null?
                                  "${controller.userdata!.value!.data!.lineManager}":"•••",
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ))
                            ],
                          ),
                          Divider(
                            thickness: 2,
                            color: appColors.dividerColor,
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 105.w,
                                child: Text("City",
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                              SizedBox(
                                width: 47.h,
                              ),
                              Text("${controller.userdata!.value!.data!.zone}",
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ))
                            ],
                          ),
                          Divider(
                            thickness: 2,
                            color: appColors.dividerColor,
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 105.w,
                                child: Text("Address",
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                              SizedBox(
                                width: 47.h,
                              ),
                              Flexible(
                                child: Text(
                                    "${controller.userdata!.value!.data!.address}",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    )),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 2,
                            color: appColors.dividerColor,
                          ),
                          SizedBox(
                            height: 25.h,
                          ),

                          SizedBox(
                            width: 200.w,
                            child: ElevatedButton(
                              onPressed: () {
                                logoutDialog();
                              },
                              child: const Text("Logout"),
                              style: ElevatedButton.styleFrom(
                                primary: AppColors().gradientColor1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  logoutDialog(){
    Get.defaultDialog(
        title: "Warning!",
        content: Column(
          children: [
            const Text("Do you want to logout ?"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    controller.logout();
                  },
                  child: const Text("Yes"),
                ),
                MaterialButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("No"),
                )
              ],
            )
          ],
        ));
  }
}
