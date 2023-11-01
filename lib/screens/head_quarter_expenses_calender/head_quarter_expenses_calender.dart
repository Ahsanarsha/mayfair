import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mayfair/export.dart';
import 'package:mayfair/utills/utills.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../data/base/base_url.dart';

class HeadQuarterExpensesCalender
    extends GetView<HeadQuarterExpensesCalenderController> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  HeadQuarterExpensesCalender(this.selectedDates);

  final Map<String, dynamic>? selectedDates;
  var formatter = NumberFormat('#,##,000');

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HeadQuarterExpensesCalenderController>(
      initState: (_) {
        try {
          controller.startDate =
              selectedDates!["date_from"].toString().split(" ")[0];
          controller.endDate =
              selectedDates!["date_to"].toString().split(" ")[0];
          log(controller.returnDate().toString());
        } catch (error) {
          log(error.toString());
        }
      },
      builder: (_) => WillPopScope(
        onWillPop: () async {
          Get.clearRouteTree();
          Get.offAll(() => Homepage(), binding: Appbindings());
          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: appColors.white,
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Add Head Quarter Expenses",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: appColors.appBarColor,
            leading: IconButton(
              onPressed: () {
                Get.clearRouteTree();
                Get.offAll(() => Homepage(), binding: Appbindings());
              },
              icon: Icon(Icons.arrow_back, color: appColors.black),
            ),
          ),
          drawer: const CustomDrawer(),
          drawerScrimColor: appColors.transparent,
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(height: 4.h),
                  getGrandTotalContainer(),
                  SizedBox(height: 28.h),
                  // getAddTravelingExpensesLink(),
                  // SizedBox(
                  //   height: 32.h,
                  // ),
                  getHeadQuartersTownExpensesHeading(),
                  SizedBox(
                    height: 14.h,
                  ),
                  getAutofillThisMonthButton(),
                  SizedBox(
                    height: 14.h,
                  ),
                  getCalendar(context),
                  SizedBox(
                    height: 5.3.h,
                  ),
                  getTotalAmountFromCalendar(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget getGrandTotalContainer() {
    return Container(
      width: double.infinity,
      height: 131.w,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          width: 1.0,
          color: const Color.fromRGBO(112, 112, 112, 1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(formatter.format(int.parse(controller.total.value)),
            style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: appColors.white),
          ),
          SizedBox(height: 10.h),
          Text(
            "Grand Total",
            style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: appColors.white),
          ),
        ],
      ),
    );
  }
  Widget getAddTravelingExpensesLink() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          // //print("Add Travelling Expenses Button Clicked");
          // Get.offAll(() => AddTravelExpensesScreen(), binding: Appbindings());
        },
        child: Text(
          appConstants.addTravelExpenses,
          style: GoogleFonts.inter(
            decoration: TextDecoration.underline,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: appColors.gradientColor1,
          ),
        ),
      ),
    );
  }
  Widget getHeadQuartersTownExpensesHeading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          appConstants.headQuarterHeading,
          style:
              GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
  Widget getAutofillThisMonthButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.0.w),
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 201.w,
          height: 36.h,
          child: TextButton(
            onPressed: () {
              print(controller.data.length);
              if (controller.data.length <= 30) {
                controller.autoFillMonthHeadQuarterData();
              }
            },
            style: TextButton.styleFrom(
              primary: appColors.white,
              backgroundColor: appColors.gradientColor1,
            ),
            child: Text(
              appConstants.autofillThisMonth,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: appColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getCalendar(BuildContext context) {
    RxList data = controller.data;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.w),
      child: TableCalendar(
        headerStyle: HeaderStyle(
            headerPadding: EdgeInsets.symmetric(
              vertical: 5.h,
              horizontal: 11.w,
            ),
            titleTextStyle: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
            formatButtonVisible: false,
            decoration: const BoxDecoration(color: Colors.black),
            rightChevronVisible: false,
            leftChevronVisible: false),
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, day, focusedDay) {
            final text = DateFormat.d().format(day);
            String formattedDate =
            DateFormat('yyyy-MM-dd').format(day);
            return Container(
              color: const Color.fromRGBO(214, 155, 68, 1),
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text,
                              style: TextStyle(
                                color: appColors.white,
                                fontSize: 11.sp,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (int i = 0; i < data.length; i++)
                                  data[i]['date'] == formattedDate &&
                                      data[i]['data_added']
                                      ? ImageIcon(
                                    AssetImage(
                                      Assets().calendar_check,
                                    ),
                                    color: AppColors().greenCheck,
                                  )
                                      : Container(),
                              ],
                            ),
                          ],
                        ),
                      )),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0.w, vertical: 4.0.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < data.length; i++)
                              data[i]['date'] == formattedDate
                                  ? Text(
                                formatter.format(
                                    int.parse(data[i]['expense'])),
                                style: TextStyle(
                                    color: appColors.white,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400),
                              )
                                  : Container(),
                          ],
                        ),
                      )),
                ],
              ),
            );
          },
          outsideBuilder: (context, selectedDay, focusedDay) {
            final text = DateFormat.d().format(selectedDay);
            return Container(
              color: Color.fromRGBO(230, 230, 230, 1),
              child: Center(),
            );
          },
          defaultBuilder: (context, selectedDay, focusedDay) {
            final text = DateFormat.d().format(selectedDay);
            String formattedDate =
            DateFormat('yyyy-MM-dd').format(selectedDay);
            return Container(
              color: Color.fromRGBO(242, 242, 242, 1),
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text,
                              style: TextStyle(
                                color: selectedDay.weekday == 7
                                    ? Color.fromRGBO(214, 155, 68, 1)
                                    : appColors.greyText,
                                fontSize: 11.sp,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (int i = 0; i < data.length; i++)
                                  data[i]['date'] == formattedDate &&
                                      data[i]['data_added']
                                      ? ImageIcon(
                                    AssetImage(Assets().calendar_check),
                                    color: AppColors().greenCheck,
                                  )
                                      : Container(),
                              ],
                            ),
                          ],
                        ),
                      )),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0.w, vertical: 4.0.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < data.length; i++)
                              data[i]['date'] == formattedDate
                                  ? Text(
                                formatter.format(
                                    int.parse(data[i]['expense'])),
                                style: TextStyle(
                                    color: appColors.greyText,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400),
                              )
                                  : Container(),
                          ],
                        ),
                      )),
                ],
              ),
            );
          },
          disabledBuilder: (context, selectedDay, focusedDay) {
            final text = DateFormat.d().format(selectedDay);
            return Container(
              color: Color.fromRGBO(230, 230, 230, 1),
              child: Center(),
            );
          },
          todayBuilder: (context, selectedDay, focusedDay) {
            final text = DateFormat.d().format(selectedDay);
            String formattedDate =
            DateFormat('yyyy-MM-dd').format(selectedDay);
            return Container(
              color: const Color.fromRGBO(242, 242, 242, 1),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(214, 155, 68, 0.5),
                ),
                child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                text,
                                style: TextStyle(
                                  color: appColors.white,
                                  fontSize: 11.sp,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  for (int i = 0; i < data.length; i++)
                                    data[i]['date'] == formattedDate &&
                                        data[i]['data_added']
                                        ? ImageIcon(
                                      AssetImage(
                                          Assets().calendar_check),
                                      color: AppColors().greenCheck,
                                    )
                                        : Container(),
                                ],
                              ),
                            ],
                          ),
                        )),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.0.w, vertical: 4.0.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0; i < data.length; i++)
                                data[i]['date'] == formattedDate
                                    ? Text(
                                  formatter.format(
                                      int.parse(data[i]['expense'])),
                                  style: TextStyle(
                                      color: appColors.white,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w400),
                                )
                                    : Container(),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            );
          },
          dowBuilder: (context, day) {
            final text = DateFormat.E().format(day);
            return Container(
              color: Color.fromRGBO(214, 155, 68, 1),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
        firstDay: DateTime.utc(
            controller.returnDate().year, controller.returnDate().month, 1),
        lastDay: DateTime.utc(controller.returnDate().year,
            controller.returnDate().month + 1, 31),
        focusedDay: controller.returnDate(),
        selectedDayPredicate: (day) {
          return isSameDay(controller.selectedDay.value, day);
        },
        onDayLongPressed: (selectedDay, focusedDay) {
          String conditionalDate = selectedDay.toString().substring(0,selectedDay.toString().indexOf(" "));
          for (int i = 0; i < data.length; i++) {
            if (data[i]['status'] == 'Pending'
                &&
                data[i]['data_added'] == true && data[i]['date'] == conditionalDate) {
              String formattedDate =
              DateFormat('yyyy-MM-dd').format(selectedDay);

              if (selectedDay.isAfter(selectedDates!["date_from"]) &&
                  selectedDay.isBefore((selectedDates!["date_to"] as DateTime)
                      .add(Duration(days: 1)))) {
                String formattedDate =
                DateFormat('yyyy-MM-dd').format(selectedDay);
                controller.selectedDay.value = selectedDay;
                controller.focusedDay.value = focusedDay;
                controller.checkIfAlreadyFilled(formattedDate,true);
              }
              return;
            }
          }
          try {
            if (selectedDay.isAfter(selectedDates!["date_from"]) &&
                selectedDay.isBefore((selectedDates!["date_to"] as DateTime)
                    .add(Duration(days: 1)))) {
              String formattedDate =
              DateFormat('yyyy-MM-dd').format(selectedDay);
              controller.selectedDay.value = selectedDay;
              controller.focusedDay.value = focusedDay;
              controller.checkIfAlreadyFilled(formattedDate,false);
            } else {
              showMessage(
                  title: "ERROR",
                  message:
                  "Can't Add Expenses At ${DateFormat("dd MMMM").format(selectedDay)}");
            }
          } catch (error) {
            log(error.toString());
            String formattedDate =
            DateFormat('yyyy-MM-dd').format(selectedDay);
            controller.selectedDay.value = selectedDay;
            controller.focusedDay.value = focusedDay;
            controller.checkIfAlreadyFilled(formattedDate,false);
          }
        },
        onPageChanged: (focusedDay) {
          controller.focusedDay.value = focusedDay;
        },
        onDisabledDayTapped: (date) {
          //print("on disabled tapped");
        },
        onDisabledDayLongPressed: (date) {},
        calendarFormat: CalendarFormat.month,
        onDaySelected: (selectedDay, focusedDay) {
          controller.selectedDay.value = selectedDay;
          controller.focusedDay.value = focusedDay;
        },
      ),
    );
  }
  Widget getTotalAmountFromCalendar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Total",
              style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: appColors.headingHint)),
          SizedBox(width: 17.w),
          Obx(
            () => Text(formatter.format(int.parse(controller.total.value)),
                style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: appColors.black)),
          ),
        ],
      ),
    );
  }
}
