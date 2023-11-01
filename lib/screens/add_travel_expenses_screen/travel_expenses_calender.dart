import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mayfair/data/model/GetTravelExpenseByIdModel.dart';
import 'package:mayfair/export.dart';
import 'package:mayfair/screens/add_travel_expenses_screen/model/data_pass_model.dart';
import 'package:mayfair/utills/utills.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../widgets/app_bar_with_title.dart';

class TravelExpensesCalender extends GetView<TravelExpensesCalenderController> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, dynamic>? selectedDates;
  var formatter = NumberFormat('#,##,000');

  TravelExpensesCalender(this.selectedDates);

  @override
  Widget build(BuildContext context) {
    print("this is selected Date = $selectedDates");
    return GetBuilder<TravelExpensesCalenderController>(
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
              "Add Travel Expenses",
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
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 28.h,
                ),
                getCalendar(context),
                SizedBox(
                  height: 5.3.h,
                ),
                getTotalAmountFromCalendar(context),
                SizedBox(
                  height: 23.h,
                ),
                getTotalAmountList(context),
              ],
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
            headerPadding:
                EdgeInsets.symmetric(vertical: 5.h, horizontal: 11.w),
            titleTextStyle: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
            formatButtonVisible: false,
            decoration: BoxDecoration(color: Colors.black),
            rightChevronVisible: false,
            leftChevronVisible: false),
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, day, focusedDay) {
            final text = DateFormat.d().format(day);
            String formattedDate = DateFormat('yyyy-MM-dd').format(day);
            return Obx(
              () => Container(
                color: Color.fromRGBO(214, 155, 68, 1),
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
                                            double.parse(data[i]['expense'])),
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
          outsideBuilder: (context, selectedDay, focusedDay) {
            final text = DateFormat.d().format(selectedDay);
            return Container(
              color: const Color.fromRGBO(230, 230, 230, 1),
              child: const Center(),
            );
          },
          defaultBuilder: (context, selectedDay, focusedDay) {
            final text = DateFormat.d().format(selectedDay);
            String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
            return Obx(
              () => Container(
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
                                    buildTick(data, i, formattedDate),
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
                                            double.parse(data[i]['expense'])).toString(),
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
              ),
            );
          },
          disabledBuilder: (context, selectedDay, focusedDay) {
            final text = DateFormat.d().format(selectedDay);
            return Container(
              color: const Color.fromRGBO(230, 230, 230, 1),
              child: const Center(),
            );
          },
          todayBuilder: (context, selectedDay, focusedDay) {
            final text = DateFormat.d().format(selectedDay);
            String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
            return Obx(
              () => Container(
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
                                      buildTick(data, i, formattedDate),
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
              ),
            );
          },
          dowBuilder: (context, day) {
            final text = DateFormat.E().format(day);
            return Container(
              color: const Color.fromRGBO(214, 155, 68, 1),
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white),
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

          print(selectedDay.toString());
          print(focusedDay.toString());
          print("----------------------");
          print(selectedDates!["date_from"].toString());
          print(selectedDates!["date_to"].toString());
          print("----------------------");
          if (selectedDay.isAfter(selectedDates!["date_from"]) &&
              selectedDay.isBefore((selectedDates!["date_to"] as DateTime)
                  .add(Duration(days: 1)))) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
            controller.selectedDay.value = selectedDay;
            controller.focusedDay.value = focusedDay;

            controller.checkIfAlreadyFilled(formattedDate);
            controller.data.forEach((element) {
              print("Yes");
              print(element.toString());
            });
          } else {
            showMessage(
                title: "ERROR",
                message:
                    "Can't Add Expenses At ${DateFormat("dd MMMM").format(selectedDay)}");
          }
          controller.update();
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
          //print("SELECTED DATE ${selectedDay} AND FOCUS DATE ${focusedDay}");
          controller.selectedDay.value = selectedDay;
          controller.focusedDay.value = focusedDay;
        },
      ),
    );
  }

  Widget buildTick(dynamic data, int i, String formattedDate) {
    return data[i]['date'] == formattedDate && data[i]['data_added']
        ? ImageIcon(
            AssetImage(Assets().calendar_check),
            color: AppColors().greenCheck,
          )
        : Container();
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
          Text(
            formatter.format(double.parse(controller.total.toString())),
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: appColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget getTotalAmountList(context) {
    return
      controller.isLoading.value == false
        ?
    ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 27.w),
            shrinkWrap: true,
            itemCount: controller.getTravelExpenseByID!.value!.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return _listWidget(context,
                  controller.getTravelExpenseByID!.value!.data![index]);
            },
          )
        : const Center(
            child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
          )
    ;
  }

  Widget _listWidget(BuildContext context, Data data) {
    final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
    final String formattedDate = dateFormatter.format(DateTime.parse(data.currentDate.toString()));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        width: getScreenWidth(context),
        padding: EdgeInsets.fromLTRB(13.w, 20.h, 7.w, 20.h),
        decoration: BoxDecoration(
          color: appColors.grey,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Date",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: appColors.headingHint,
                    )),
                SizedBox(
                  height: 19.h,
                ),
                Text(formattedDate,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    )),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Travelled To",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: appColors.headingHint,
                    )),
                SizedBox(
                  height: 19.h,
                ),
                Text(data.travelTo.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    )),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Expense",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: appColors.headingHint,
                    )),
                SizedBox(
                  height: 19.h,
                ),
                Text(formatter.format(double.parse(data.grandTotal.toString())),
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    )),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               data.nightStay == "0"
                      ? Text(
                    'Same_Day_Return',
                    style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: appColors.black),
                  )
                      : Text(
                    'Night Stay',
                    style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: appColors.black),
                  ),

                SizedBox(
                  height: 19.h,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierColor: appColors.white.withOpacity(0.85),
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: 18.h),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Night Stay Note",
                                                style: GoogleFonts.inter(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(width: 66.w),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Ink(
                                                  width: 20.w,
                                                  height: 20.h,
                                                  child: const Icon(
                                                    Icons.close,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 32.h,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 22.w, right: 24.w),
                                          child: Container(
                                              width: 328.w,
                                              height: 127.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2.0),
                                                color: appColors.white,
                                              ),
                                              child:
                                                  Text(data.note ?? "Empty")),
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              width: 141.w,
                                              height: 52.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2.0),
                                                color: appColors.gradientColor1,
                                              ),
                                              child: TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text("Dismiss",
                                                      style: GoogleFonts.inter(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: appColors.white,
                                                      )))),
                                        )
                                      ]));
                            },
                          );
                        },
                        child: SizedBox(
                          width: 15.w,
                          height: 15.h,
                          child: Image.asset(
                            appAssets.userNotes,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      data.status == 'Approved' ||
                              data.status == 'Pending' ||
                              data.status == 'Rejected'
                          ? Container()
                          : IconButton(
                              onPressed: () {
                                RxBool isUpdate = true.obs;
                                var dateTime =
                                    DateTime.parse(data.currentDate!);
                                List<TravelExpenseData> listTravel =[];
                                data.travelExpenseData!.forEach((element) {
                                  TravelExpenseData newObj = TravelExpenseData.fromJson(element);
                                  listTravel.add(newObj);
                                });
                                for(int i =0 ;i<=listTravel.length;i++){
                                  if(listTravel[i].name == "Kilometer"){
                                    listTravel.remove(listTravel[i]);
                                  }
                                  if(listTravel[i].name == "Fuel amount"){
                                    listTravel.remove(listTravel[i]);
                                  }
                                  if(listTravel[i].name == "Kilometer"){
                                    listTravel.remove(listTravel[i]);
                                  }
                                  if(listTravel[i].name == "Amount pkm"){
                                    listTravel.remove(listTravel[i]);
                                  }
                                  if(listTravel[i].name == "Sameday return"){
                                    listTravel.remove(listTravel[i]);
                                  }
                                  if(listTravel[i].name == "Night Stay Allowance"){
                                    listTravel.remove(listTravel[i]);
                                  }
                                  if(listTravel[i].name == "Grand total"){
                                    listTravel.remove(listTravel[i]);
                                  }
                                }

                                listTravel.forEach((element) {
                                  print(element.name);
                                  print(element.value);
                                });


                                DataPassModel model = DataPassModel(
                                  data.id.toString(),
                                  dateTime,
                                  isUpdate,
                                  data.travelTo!,
                                  data.station ?? "0",
                                  data.kilometer ?? "0",
                                  data.fuelAmount ?? "0",
                                  data.amountPkm ?? "0",
                                  data.SameDayReturn ?? "0",
                                  data.note ?? "Empty",
                                  data.grandTotal!,
                                  data.nightStay!,
                                  listTravel
                                  //data.travelExpenseData!

                                );
                                print(model.amountPkm);
                                print(model.fuelAmount);
                                print(model.grandTotal);
                                print(model.kilometer);
                                Get.to(() => AddTravelExpensesWRTDate(),
                                        binding: Appbindings(),
                                        arguments: model)
                                    ?.then(
                                  (value) => controller.getTravelExpenseById(),
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 20,
                              ))

                    ],
                  ),
                ),
                SizedBox(
                  height: 19.h,
                ),
                Row(
                  children: [
                    Text('Status : ',style: TextStyle(fontSize: 9,color: Colors.grey),),
                    Text(data.status == 'Approved'?'Approved':data.status == 'Rejected'?'Rejected':'Added',style: TextStyle(fontSize: 9,
                    color: data.status == 'Approved'?Colors.green:data.status == 'Rejected'?Colors.red:Colors.blue

                    ),),
                  ],
                ),
        ]
            ),

          ],
        ),
      ),
    );
  }
}
