import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mayfair/export.dart';
import 'package:mayfair/main.dart';
import 'package:mayfair/widgets/cache_image.dart';

class Homepage extends GetView<HomeController> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      initState: (_) {
        controller.getLastThreeAddedHQExpenseDates();
      },
      builder: (_) =>
          Scaffold(
            backgroundColor: appColors.white,
            key: _scaffoldKey,
            appBar: CustomAppBar(
              scaffoldKey: _scaffoldKey,
            ),
            drawer: CustomDrawer(),
            drawerScrimColor: appColors.transparent,
            body: controller.isLoading.isFalse
                ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getGrandTotalContainer(),
                  SizedBox(height: 20.h),
                  getProfileContainer(),
                  SizedBox(
                    height: 30.h,
                  ),
                  getDateDropDown(),
                  SizedBox(
                    height: 10.h,
                  ),
                  getHeadQuartersTownExpensesHeading(),
                  SizedBox(
                    height: 10.h,
                  ),
                  getTravelExpensesHeading(),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            )
                : Center(
              child: CircularProgressIndicator(
                color: appColors.gradientColor1,
              ),
            ),
          ),
    );
  }

  Widget getGrandTotalContainer() {
    var formatter = NumberFormat('#,##,000');
    String grandTotal = formatter.format(
        controller.totalHeadQuarterExpense.value +
            controller.totalTravelExpense.value).toString();
    return Container(
      width: double.infinity,
      height: 120.w,
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
              width: 1.0, color: const Color.fromRGBO(112, 112, 112, 1))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Grand Total Approved",
              style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: appColors.white)),
          SizedBox(height: 10.h),
          Text(grandTotal,
              style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: appColors.white)),


        ],
      ),
    );
  }

  Widget getProfileContainer() {
    // String finalUrl=

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 31.w),
      child: Row(
        children: [
          CacheImage(
              link: controller.profileData!.value!.data!.profilePhotoPath!,
              name: controller.profileData!.value!.data!.firstname!),
          SizedBox(
            width: 19.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 11.h,
              ),
              Text(
                controller.userdata.userModel!.value!.data!.name!,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget getDateDropDown() {
    return Container(
      height: 135.h,
      color: appColors.grey,
      padding: EdgeInsets.symmetric(horizontal: 33.0.w, vertical: 20.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<Map<String, dynamic>>(
            value: controller.hqExpenseDate,
            items: controller.hqExpenseDates.map((Map<String, dynamic>? value) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: value,
                child: Text(
                  DateFormat("dd MMMM").format(value!["date_from"]) +
                      " - " +
                      DateFormat("dd MMMM").format(value["date_to"]),
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (Map<String, dynamic>? date) {
              if (date != null) {
                controller.hqExpenseDate = date;
                controller.travelExpenseDate = date;
                controller.saveDate(
                    controller.hqExpenseDates.indexOf(date));
                controller.update();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget getHeadQuartersTownExpensesHeading() {
    var formatter = NumberFormat('#,##,000');
    return Card(
      color: AppColors().appBarColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appConstants.headQuarterHeading,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (constants.connectionStatus.hasConnection) {
                      controller.isLoading.value
                          ? null
                          : Get.to(
                              () =>
                              HeadQuarterExpensesCalender(
                                  controller.hqExpenseDate),
                          binding: Appbindings());
                    } else {
                      Get.defaultDialog(
                          title: "No Internet",
                          middleText: "Connect to the Internet and Restart the application!",
                          //textConfirm: "Ok",
                          onConfirm: () {
                            if (constants.connectionStatus.hasConnection) {
                              Get.back();
                            }
                          });
                    }
                  },
                  child: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors().gradientColor1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0.0,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Total Added",
                        style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w300,
                            color: appColors.black)),
                    SizedBox(width: 10,),
                    Text(formatter.format(double.parse(controller.totalHqAddedExpense.value.toString())),
                        style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: appColors.black))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Total Approved",
                        style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w300,
                            color: appColors.black)),
                    SizedBox(width: 10,),
                    Text(formatter.format(controller.totalHeadQuarterExpense.value),
                        style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: appColors.black))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getTravelExpensesHeading() {
    var formatter = NumberFormat('#,##,000');
    return Card(
      color: AppColors().appBarColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appConstants.travelHeading,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (constants.connectionStatus.hasConnection) {
                      controller.isLoading.value
                          ? null
                          : Get.to(
                              () =>
                              TravelExpensesCalender(controller.travelExpenseDate),
                          binding: Appbindings());
                    } else {
                      Get.defaultDialog(
                          title: "No Internet",
                          middleText: "Connect to the Internet and Restart the application",
                          // textConfirm: "Ok",
                          onConfirm: () {
                            if (constants.connectionStatus.hasConnection) {
                              Get.back();
                            }
                          });
                    }
                  },
                  child: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors().gradientColor1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0.0,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(20),
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Total Added",
                          style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w300,
                              color: appColors.black)),
                      SizedBox(width: 10,),
                      Text(formatter.format(controller.totalTravelAddedExpense.value),
                          style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: appColors.black))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Total Approved",
                          style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w300,
                              color: appColors.black)),
                      SizedBox(width: 10,),
                      Text(formatter.format(controller.totalTravelExpense.value),
                          style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: appColors.black))
                    ],
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

}
