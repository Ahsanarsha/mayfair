import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mayfair/export.dart';
import 'package:mayfair/main.dart';
import 'package:mayfair/res/export.dart';

import '../screens/travel_approval_screen/travel_approvals_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 319.w,
        padding: EdgeInsets.only(top: AppBar().preferredSize.height),
        child: Drawer(
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 29.0.w,vertical: 43.h),

            child: Container(

              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Get.off(() => Homepage(), binding: Appbindings());
                    },
                    child: Ink(
                      width: double.infinity,
                      height: 23.h,
                      child: Row(
                        children: [
                          Image.asset(
                            appAssets.dashboard,
                            width: 23.w,
                            height: 23.h,
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            appConstants.dashboard,
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      )
                    ),
                  ),
                  //Head Quarter Approval
                  SizedBox(height: 46.h),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Get.off(() => ApprovalScreen(), binding: Appbindings());
                    },
                    child: Ink(
                      width: double.infinity,
                      height: 23.h,
                      child: Row(
                        children: [
                          Image.asset(
                            appAssets.approval,
                            width: 23.w,
                            height: 23.h,
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            appConstants.hq_approvals,
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                        )
                    ),
                  ),
                  //Travel Approval
                  SizedBox(height: 46.h),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Get.off(() => TravelApprovalScreen(), binding: Appbindings());
                    },
                    child: Ink(
                        width: double.infinity,
                        height: 23.h,
                        child: Row(
                          children: [
                            Image.asset(
                              appAssets.approval,
                              width: 23.w,
                              height: 23.h,
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              appConstants.travel_approvals,
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        )
                    ),
                  ),
                  SizedBox(height: 46.h),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Get.off(() => ProfileScreen(), binding: Appbindings());
                    },
                    child: Ink(
                        width: double.infinity,
                        height: 23.h,
                        child: Row(
                          children: [
                            Image.asset(
                              appAssets.user,
                              width: 23.w,
                              height: 23.h,
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              appConstants.myProfile,
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        )
                    ),
                  ),
                  SizedBox(height: 46.h),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Get.off(() => SettingsScreen(), binding: Appbindings());
                    },
                    child: Ink(
                        width: double.infinity,
                        height: 23.h,
                        child: Row(
                          children: [
                            Image.asset(
                              appAssets.settings,
                              width: 23.w,
                              height: 23.h,
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              appConstants.settings,
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        )
                    ),
                  ),
                  Spacer(),
                  Ink(
                      width: double.infinity,
                      height: 23.h,
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outlined,
                            color: Colors.black38,
                          ),
                          SizedBox(width: 16.w),
                          Row(
                            children: [
                              Text("App version: ",style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),),
                              Text( appVersion),
                            ],
                          )
                        ],
                      )
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
