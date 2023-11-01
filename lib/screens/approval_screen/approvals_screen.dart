import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mayfair/export.dart';
import 'package:mayfair/widgets/app_bar_with_title.dart';

import '../../data/base/base_url.dart';

class ApprovalScreen extends GetView<ApprovalsController> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldTabBarKey = GlobalKey<ScaffoldState>();

  var formatter = NumberFormat('#,##,000');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.off(() => Homepage(), binding: Appbindings());
        return Future.value(true);
      },
      child: GetBuilder<ApprovalsController>(
        builder: (_) => DefaultTabController(
          length: 2,
          child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBarWithTitle("H.Q Approvals", false,
                  scaffoldKey: _scaffoldKey,showRefresh: true,onPressed: (){
                  String startDate = BaseUrls.dateFromHQ.substring(0, 10);
                  String endDate = BaseUrls.dateToHQ.substring(0, 10);
                  controller.getAcceptedFromTo(startDate, endDate);
                  },),
              drawer: CustomDrawer(),
              drawerScrimColor: appColors.transparent,
              body: Scaffold(
                key: _scaffoldTabBarKey,
                appBar: CustomApprovalsAppBar(scaffoldKey: _scaffoldTabBarKey),
                body: controller.isLoading.value
                    ? Center(
                        child: SpinKitCircle(
                          color: AppColors().gradientColor1,
                        ),
                      )
                    : TabBarView(
                        controller: controller.tabController,
                        children: [
                          getApprovedOnes(context),
                          getRejectedOnes(context),
                          getForwardedOnes(context),
                        ],
                      ),
              )),
        ),
      ),
    );
  }

  Widget getApprovedOnes(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 5),
                child: Card(
                  child: GestureDetector(
                    onTap: () {
                      String startDate = BaseUrls.dateFromHQ.substring(0, 10);
                      String endDate = BaseUrls.dateToHQ.substring(0, 10);
                      controller.getAcceptedFromTo(startDate, endDate);
                    },
                    child: Icon(
                      Icons.refresh,
                      color: AppColors().gradientColor1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Total : ${formatter.format(int.parse(controller.acceptedTotal.toString()))}",
                      style: GoogleFonts.inter(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 27.w, right: 26.w),
            child: Row(
              children: [
                Container(
                  width: 175.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: appColors.white,
                      onPrimary: appColors.borderColor,
                    ),
                    onPressed: () {
                      controller.approveDateFrom(context);
                    },
                    child: Container(
                      width: 135.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (controller.approvedDateFrom.toString().isEmpty)
                                ? "From"
                                : controller.approvedDateFrom.toString(),
                            style: GoogleFonts.inter(
                                fontSize: 14.sp, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Image.asset(
                            appAssets.calendar,
                            width: 19.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 25.w,
                ),
                Container(
                  width: 175.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: appColors.white,
                      onPrimary: appColors.borderColor,
                    ),
                    onPressed: () {
                      controller.approveDateTo(context);
                    },
                    child: Container(
                      width: 144.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (controller.approvedDateTo.toString().isEmpty)
                                ? "To"
                                : controller.approvedDateTo.toString(),
                            style: GoogleFonts.inter(
                                fontSize: 14.sp, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Image.asset(
                            appAssets.calendar,
                            width: 19.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 36.h,
          ),
          Obx(
            () => Expanded(
              child: controller.acceptedModel!.value!.data == null
                  ? const Center(
                      child: Text("Data not found"),
                    )
                  : ListView(
                      padding: EdgeInsets.only(left: 25.w, right: 23.w),
                      children: [
                        ...controller.acceptedModel!.value!.data!.map((e) {
                          int overlimitPrice = 0;
                          int grandTotal = 0;
                          for (int i = 0; i < e.expenseId!.length; i++) {
                            grandTotal += int.parse(e.expenseId![i].value!);
                            overlimitPrice += int.parse(e.expenseId![i].overLimitAmount ?? "0");
                          }
                          //(int.parse(e.expenseId!.orginalValue!)-int.parse(e.expenseId!.value!)).toString();

                          return Container(
                              color: appColors.white,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 16.h,
                                  bottom: 5.h,
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: appColors.transparent),
                                  child: Card(
                                    color: const Color(0xFFF8F8F8),
                                    elevation: 0.7,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ExpansionTile(
                                        childrenPadding: EdgeInsets.zero,
                                        tilePadding: EdgeInsets.zero,
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Date",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          appColors.headingHint,
                                                    )),
                                                SizedBox(
                                                  height: 18.5.h,
                                                ),
                                                Text(e.currentDate.toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: appColors.black,
                                                    ))
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Grand Total",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          appColors.headingHint,
                                                    )),
                                                SizedBox(
                                                  height: 18.5.h,
                                                ),
                                                Text(
                                                    formatter.format(int.parse(
                                                        grandTotal.toString())),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: appColors.black,
                                                    ))
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Over Limit",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          appColors.headingHint,
                                                    )),
                                                SizedBox(
                                                  height: 18.5.h,
                                                ),
                                                Text(
                                                    overlimitPrice
                                                        .toString()
                                                        .replaceAll("-", ""),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: appColors.black,
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                        children: [
                                          for (int i = 0;
                                              i < e.expenseId!.length;
                                              i++)
                                            Column(
                                              children: [
                                                if(int.parse(e.expenseId![i].value.toString())!=0)
                                                SizedBox(height: 30.h),
                                                if(int.parse(e.expenseId![i].value.toString())!=0)
                                                Container(
                                                  width: 341.5,
                                                  decoration: BoxDecoration(
                                                      color: appColors.white,
                                                      border: Border.all(
                                                        color: AppColors()
                                                            .greenCheck,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 21.h,
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 19.w,
                                                                right: 19.5.w),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                e.expenseId![i]
                                                                    .name
                                                                    .toString(),
                                                                style: GoogleFonts.poppins(
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: appColors
                                                                        .black)),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  width: 96.w,
                                                                  height: 34.h,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          color: appColors
                                                                              .white,
                                                                          border:
                                                                              Border
                                                                                  .all(
                                                                            color: AppColors()
                                                                                .greenCheck,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                  4.0)),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                      e
                                                                          .expenseId![
                                                                              i]
                                                                          .value
                                                                          .toString(),
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontSize:
                                                                            14.sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                      )),
                                                                ),
                                                                if(e.expenseId![i].mNote!=null)
                                                                SizedBox(width: 5,),
                                                                if(e.expenseId![i].mNote!=null)
                                                                  SizedBox(
                                                                    height: 20,
                                                                    width: 20,
                                                                    child:  InkWell(
                                                                        onTap:(){
                          showDialog(context: context, builder: (_){
                          return AlertDialog(
                          title: Text("Manager Comments",style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600
                          ),),
                          content: Text(e.expenseId![i].mNote.toString()),
                          );
                          });
                          },
                                                                        child: Image.asset(
                                                                          appAssets.userNotes,
                                                                          width: 30,
                                                                        ),),
                                                                  )
                                                              ],
                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 13.5.h,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if(int.parse(e.expenseId![i].value.toString())!=0)
                                                SizedBox(height: 8.6.h),
                                              ],
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                        }),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget getRejectedOnes(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 5),
                child: Card(
                  child: GestureDetector(
                    onTap: () {
                      String startDate = BaseUrls.dateFromHQ.substring(0, 10);
                      String endDate = BaseUrls.dateToHQ.substring(0, 10);
                      controller.getRejectedFromTo(startDate, endDate);
                    },
                    child: Icon(
                      Icons.refresh,
                      color: AppColors().gradientColor1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Total : ${formatter.format(int.parse(controller.rejectedTotal.toString()))}",
                      style: GoogleFonts.inter(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              )
            ],
          ),

          Padding(
            padding: EdgeInsets.only(left: 27.w, right: 26.w),
            child: Row(
              children: [
                Container(
                  width: 175.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: appColors.white,
                      onPrimary: appColors.borderColor,
                    ),
                    onPressed: () {
                      controller.rejectDateFrom(context);
                    },
                    child: Container(
                      width: 135.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (controller.rejectedDateFrom.toString().isEmpty)
                                ? "From"
                                : controller.rejectedDateFrom.toString(),
                            style: GoogleFonts.inter(
                                fontSize: 14.sp, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Image.asset(
                            appAssets.calendar,
                            width: 19.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 25.w,
                ),
                Container(
                  width: 175.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: appColors.white,
                      onPrimary: appColors.borderColor,
                    ),
                    onPressed: () {
                      controller.rejectDateTo(context);
                    },
                    child: Container(
                      width: 144.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (controller.rejectedDateTo.toString().isEmpty)
                                ? "To"
                                : controller.rejectedDateTo.toString(),
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Image.asset(
                            appAssets.calendar,
                            width: 19.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 36.h,
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 35.w),
          //   child: Text(
          //     "16 Jan - 15 Feb",
          //     style: GoogleFonts.inter(
          //       fontSize: 18.sp,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 9.h,
          // ),
          Obx(
            () => Expanded(
              child: controller.rejectedModel!.value!.data == null
                  ? const Center(
                      child: Text("Data not found"),
                    )
                  : ListView(
                      padding: EdgeInsets.only(left: 25.w, right: 23.w),
                      children: [
                        ...controller.rejectedModel!.value!.data!.map((e) {
                          int overlimitPrice = 0;
                          int grandTotal = 0;
                          for (int i = 0; i < e.expenseId!.length; i++) {
                            grandTotal += int.parse(e.expenseId![i].value!);
                            overlimitPrice += int.parse(
                                e.expenseId![i].overLimitAmount ?? "0");
                          }
                          // (int.parse(e.expenseId!.orginalValue!)-int.parse(e.expenseId!.value!)).toString();
                          return Container(
                              color: appColors.white,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 16.h,
                                  bottom: 5.h,
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: appColors.transparent),
                                  child: Card(
                                    color: const Color(0xFFF8F8F8),
                                    elevation: 0.7,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ExpansionTile(
                                        childrenPadding: EdgeInsets.zero,
                                        tilePadding: EdgeInsets.zero,
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Date",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          appColors.headingHint,
                                                    )),
                                                SizedBox(
                                                  height: 18.5.h,
                                                ),
                                                Text(e.currentDate.toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: appColors.black,
                                                    ))
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Grand Total",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          appColors.headingHint,
                                                    )),
                                                SizedBox(
                                                  height: 18.5.h,
                                                ),
                                                Text(
                                                    formatter.format(int.parse(
                                                        grandTotal.toString())),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: appColors.black,
                                                    ))
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Over Limit",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          appColors.headingHint,
                                                    )),
                                                SizedBox(
                                                  height: 18.5.h,
                                                ),
                                                Text(
                                                    "${overlimitPrice.toString().replaceAll("-", "")}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: appColors.black,
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                        children: [
                                          for (int i = 0;
                                              i < e.expenseId!.length;
                                              i++)
                                            Column(
                                              children: [
                                                if(int.parse(e.expenseId![i].value.toString())!=0)
                                                SizedBox(height: 30.h),
                                                if(int.parse(e.expenseId![i].value.toString())!=0)
                                                Container(
                                                  width: 341.5,
                                                  decoration: BoxDecoration(
                                                      color: appColors.white,
                                                      border: Border.all(
                                                        color: AppColors()
                                                            .gradientColor1,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 21.h,
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 19.w,
                                                                right: 19.5.w),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                e.expenseId![i]
                                                                    .name
                                                                    .toString(),
                                                                style: GoogleFonts.poppins(
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: appColors
                                                                        .black)),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  width: 96.w,
                                                                  height: 34.h,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          color: appColors
                                                                              .white,
                                                                          border:
                                                                              Border
                                                                                  .all(
                                                                            color: AppColors()
                                                                                .gradientColor1,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                  4.0)),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                      e
                                                                          .expenseId![
                                                                              i]
                                                                          .value
                                                                          .toString(),
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontSize:
                                                                            14.sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                      )),
                                                                ),
                                                                if(e.expenseId![i].mNote!=null)
                                                                  SizedBox(width: 5,),
                                                                if(e.expenseId![i].mNote!=null)
                                                                  SizedBox(
                                                                    height: 20,
                                                                    width: 20,
                                                                    child:  InkWell(
                                                                      onTap:(){
                                                                        showDialog(context: context, builder: (_){
                                                                          return AlertDialog(
                                                                            title: Text("Manager Comments",style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16.sp,
                                                                                fontWeight: FontWeight.w600
                                                                            ),),
                                                                            content: Text(e.expenseId![i].mNote.toString()),
                                                                          );
                                                                        });
                                                                      },
                                                                      child: Image.asset(
                                                                        appAssets.userNotes,
                                                                        width: 30,
                                                                      ),),
                                                                  )
                                                              ],
                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 13.5.h,
                                                      ),
                                                      // Container(
                                                      //   width: 341.5.w,
                                                      //   decoration:
                                                      //       BoxDecoration(
                                                      //     border: Border.all(
                                                      //       color: AppColors()
                                                      //           .gradientColor1,
                                                      //       width: 2.0,
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      // SizedBox(
                                                      //   height: 24.5.h,
                                                      // ),
                                                      // Padding(
                                                      //     padding:
                                                      //         EdgeInsets.only(
                                                      //             right:
                                                      //                 33.5.w),
                                                      //     child: Row(
                                                      //       mainAxisAlignment:
                                                      //           MainAxisAlignment
                                                      //               .end,
                                                      //       children: [
                                                      //         Text(
                                                      //           "Manager Remarks",
                                                      //           style:
                                                      //               GoogleFonts
                                                      //                   .poppins(
                                                      //             fontSize:
                                                      //                 14.sp,
                                                      //             fontWeight:
                                                      //                 FontWeight
                                                      //                     .w600,
                                                      //             color:
                                                      //                 appColors
                                                      //                     .black,
                                                      //           ),
                                                      //         ),
                                                      //         SizedBox(
                                                      //           width: 36.w,
                                                      //         ),
                                                      //         Container(
                                                      //           width: 15.w,
                                                      //           height: 15.h,
                                                      //           child: Image.asset(
                                                      //               appAssets
                                                      //                   .userNotes),
                                                      //         )
                                                      //       ],
                                                      //     )),
                                                      // SizedBox(
                                                      //   height: 24.4.h,
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                                if(int.parse(e.expenseId![i].value.toString())!=0)
                                                SizedBox(height: 8.6.h),
                                              ],
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                        }),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget getForwardedOnes(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 20,left: 50),
        height: 30,
        child: ElevatedButton(
          onPressed: controller.pendingModel!.value!.data!.isEmpty
              ? null
              : () {
                  //logoutDialog();
                  controller.submitHQexpense();
                },
          child: const Text("Submit"),
          style: ElevatedButton.styleFrom(
            primary: AppColors().gradientColor1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2.0,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 5),
                  child: Card(
                    child: GestureDetector(
                      onTap: () {
                        String startDate = BaseUrls.dateFromHQ.substring(0, 10);
                        String endDate = BaseUrls.dateToHQ.substring(0, 10);
                        controller.getPendingFromTo(startDate, endDate);
                      },
                      child: Icon(
                        Icons.refresh,
                        color: AppColors().gradientColor1,
                      ),
                    ),
                  ),
                ),
                Obx(
                      () => Padding(
                    padding: const EdgeInsets.only(right: 20, top: 5),
                    child: Card(
                      child: GestureDetector(
                        onTap: () {
                          controller.isChecked.value =
                          !controller.isChecked.value;
                          controller.selectAll.value = true;
                          controller.AllChecked(controller.isChecked.value);
                          controller.update();
                        },
                        child: controller.isChecked.isFalse
                            ? Icon(
                          Icons.check_box_outlined,
                          color: AppColors().gradientColor1,
                        )
                            : Icon(Icons.check_box,
                            color: AppColors().gradientColor1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  child: Obx(
                    () => Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Total : ${formatter.format(int.parse(controller.pendingTotal.toString()))}",
                        style: GoogleFonts.inter(
                            fontSize: 14.sp, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                )
              ],
            ),

            Padding(
              padding: EdgeInsets.only(left: 27.w, right: 26.w),
              child: Row(
                children: [
                  Container(
                    width: 175.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: appColors.white,
                        onPrimary: appColors.borderColor,
                      ),
                      onPressed: () {
                        controller.pendingsDateFrom(context);
                      },
                      child: Container(
                        width: 135.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (controller.pendingDateFrom.toString().isEmpty)
                                  ? "From"
                                  : controller.pendingDateFrom.toString(),
                              style: GoogleFonts.inter(
                                  fontSize: 14.sp, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Image.asset(
                              appAssets.calendar,
                              width: 19.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 25.w,
                  ),
                  Container(
                    width: 175.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: appColors.white,
                        onPrimary: appColors.borderColor,
                      ),
                      onPressed: () {
                        controller.pendingsDateTo(context);
                      },
                      child: Container(
                        width: 144.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (controller.pendingDateTo.toString().isEmpty)
                                  ? "To"
                                  : controller.pendingDateTo.toString(),
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Image.asset(
                              appAssets.calendar,
                              width: 19.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 36.h,
            ),
            Obx(
              () => Expanded(
                child: controller.rejectedModel!.value!.data == null
                    ? const Center(
                        child: Text("Data not found"),
                      )
                    : ListView(
                        padding: EdgeInsets.only(left: 25.w, right: 23.w),
                        children: [
                          ...controller.pendingModel!.value!.data!.map((e) {
                            int overlimitPrice = 0;
                            int grandTotal = 0;
                            for (int i = 0; i < e.expenseId!.length; i++) {
                              grandTotal += int.parse(e.expenseId![i].value!);
                              overlimitPrice += int.parse(
                                  e.expenseId![i].overLimitAmount ?? "0");
                            }
                            return Container(
                                color: appColors.white,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 16.h,
                                    bottom: 5.h,
                                  ),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: appColors.transparent,
                                    ),
                                    child: Card(
                                      color: const Color(0xFFF8F8F8),
                                      elevation: 0.7,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ExpansionTile(
                                          childrenPadding: EdgeInsets.zero,
                                          tilePadding: EdgeInsets.zero,
                                          title: IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text("Date",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 11.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: appColors
                                                              .headingHint,
                                                        )),
                                                    SizedBox(
                                                      height: 18.5.h,
                                                    ),
                                                    Text(e.currentDate.toString(),
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: appColors.black,
                                                        ))
                                                  ],
                                                ),
                                                VerticalDivider(color: Colors.green ,width: 2.0,),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text("Grand Total",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 11.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: appColors
                                                              .headingHint,
                                                        )),
                                                    SizedBox(
                                                      height: 18.5.h,
                                                    ),
                                                    Text(
                                                        formatter.format(
                                                            int.parse(grandTotal
                                                                .toString())),
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: appColors.black,
                                                        ))
                                                  ],
                                                ),
                                                VerticalDivider(color: Colors.green ,width: 2.0,),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text("Over Limit",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 11.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: appColors
                                                              .headingHint,
                                                        )),
                                                    SizedBox(
                                                      height: 18.5.h,
                                                    ),
                                                    Text(
                                                        "${overlimitPrice.toString().replaceAll("-", "")}",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: appColors.black,
                                                        ))
                                                  ],
                                                ),
                                                VerticalDivider(color: Colors.green ,width: 2.0,),

                                                // (int.parse(e.expenseId!.orginalValue!)-int.parse(e.expenseId!.value!)).toString();
                                                Column(
                                                  children: [
                                                    Obx(
                                                          () => Checkbox(
                                                        checkColor: AppColors()
                                                            .white,
                                                        activeColor:AppColors()
                                                            .gradientColor1,
                                                        value: controller.selectAll.value ? controller.isChecked.value
                                                            : controller.isContain(e.id.toString()),
                                                        onChanged: (value) {
                                                          controller.selectAll.value = false;
                                                          if (controller.isContain(e.id.toString())) {
                                                            controller.removeSelectedItem(e.id.toString());
                                                            print("in if");
                                                          } else {
                                                            controller.addSelectedItem(e.id.toString());
                                                            print("in else");
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text('Status : ',style: TextStyle(fontSize: 9,color: Colors.grey),),
                                                        Text(e.status == 'Approved'?'Approved':e.status == 'Rejected'?'Rejected':'Added',style: TextStyle(fontSize: 9,
                                                            color: e.status == 'Approved'?Colors.green:e.status == 'Rejected'?Colors.red:Colors.blue

                                                        ),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                VerticalDivider(color: Colors.green ,width: 2.0,),

                                              ],
                                            ),
                                          ),
                                          children: [
                                            for (int i = 0;
                                                i < e.expenseId!.length;
                                                i++)
                                              Column(
                                                children: [
                                                  SizedBox(height: 30.h),
                                                  Container(
                                                    width: 341.5,
                                                    decoration: BoxDecoration(
                                                        color: appColors.white,
                                                        border: Border.all(
                                                          color: AppColors()
                                                              .yellowCheck,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 21.h,
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 19.w,
                                                                  right:
                                                                      19.5.w),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  e
                                                                      .expenseId![
                                                                          i]
                                                                      .name
                                                                      .toString(),
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize:
                                                                          14.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: appColors
                                                                          .black)),
                                                              Container(
                                                                width: 96.w,
                                                                height: 34.h,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: appColors
                                                                            .white,
                                                                        border: Border
                                                                            .all(
                                                                          color:
                                                                              AppColors().yellowCheck,
                                                                          width:
                                                                              2.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(4.0)),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    e
                                                                        .expenseId![
                                                                            i]
                                                                        .value
                                                                        .toString(),
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          14.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    )),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 13.5.h,
                                                        ),
                                                        // Container(
                                                        //   width: 341.5.w,
                                                        //   decoration:
                                                        //       BoxDecoration(
                                                        //     border: Border.all(
                                                        //       color: AppColors()
                                                        //           .gradientColor1,
                                                        //       width: 2.0,
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                        // SizedBox(
                                                        //   height: 24.5.h,
                                                        // ),
                                                        // Padding(
                                                        //     padding:
                                                        //         EdgeInsets.only(
                                                        //             right:
                                                        //                 33.5.w),
                                                        //     child: Row(
                                                        //       mainAxisAlignment:
                                                        //           MainAxisAlignment
                                                        //               .end,
                                                        //       children: [
                                                        //         Text(
                                                        //           "Manager Remarks",
                                                        //           style:
                                                        //               GoogleFonts
                                                        //                   .poppins(
                                                        //             fontSize:
                                                        //                 14.sp,
                                                        //             fontWeight:
                                                        //                 FontWeight
                                                        //                     .w600,
                                                        //             color:
                                                        //                 appColors
                                                        //                     .black,
                                                        //           ),
                                                        //         ),
                                                        //         SizedBox(
                                                        //           width: 36.w,
                                                        //         ),
                                                        //         Container(
                                                        //           width: 15.w,
                                                        //           height: 15.h,
                                                        //           child: Image.asset(
                                                        //               appAssets
                                                        //                   .userNotes),
                                                        //         )
                                                        //       ],
                                                        //     )),
                                                        // SizedBox(
                                                        //   height: 24.4.h,
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 8.6.h),
                                                ],
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                          }),
                        ],
                      ),
              ),
            ),
            SizedBox(
              height: 80.h,
            ),
          ],
        ),
      ),
    );
  }
}
