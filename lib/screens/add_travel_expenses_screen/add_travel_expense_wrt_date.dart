import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mayfair/data/model/HeadQuarterAllExpenseModel.dart';
import 'package:mayfair/export.dart';
import 'package:mayfair/screens/add_travel_expenses_screen/model/data_pass_model.dart';
import 'package:mayfair/screens/add_travel_expenses_screen/widget/drop_down.dart';

import '../../widgets/app_bar_with_title.dart';

class AddTravelExpensesWRTDate
    extends GetView<TravelExpensesWRTDateController> {
  DataPassModel model = Get.arguments;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var formatter = NumberFormat('#,##,000');

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TravelExpensesWRTDateController>(
      initState: (_) async {
        controller.model = Get.arguments;
        await controller.getTravelExpenseData();
        controller.allowanceController.text = controller.NightStay.value;
        // model.travelExpenseData!.forEach((element) {
        //   print("Details at this page are:():  Name:${element.name} Pass: ${element.value}" );
        // });
        print("BILALLALlLLL");
        for (int i = 0; i < controller.expenesList.length; i++) {
          print("Statussess: ${controller.expenseList[i].isEdit}");
          model.travelExpenseData![i].isEdit = controller.expenseList[i].isEdit;
        }
        if (model.isUpdate.value) {
          controller.travelTo.value = model.travelTo.toString();
          controller.stationTEC.text = model.station.toString();
          controller.travelledKM.value = model.kilometer.toString();
          controller.fuel_PKm.value = model.amountPkm.toString();
          controller.nightStayPerDay.value =
              model.nightStay == "0" ? false : true;
          controller.isSameDayReturn.value =
              model.sameDayReturn == "0" ? false : true;
          controller.NightStay.value = model.nightStay;
          controller.SameDayReturn.value = model.sameDayReturn;
          controller.GrandTotal.value = model.grandTotal.toString();

          controller.totalAllowance(2);
          controller.calculateTotal();
        } else {
          controller.calculateTotal();
        }
      },
      builder: (_) => Scaffold(
        appBar: AppBarWithTitle(
          "Add Traveling Expenses",
          true,
          scaffoldKey: _scaffoldKey,
        ),
        drawer: const CustomDrawer(),
        drawerScrimColor: appColors.transparent,
        body: controller.isLoading.isTrue
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.only(
                    left: 28.w, right: 28.w, top: 20.h, bottom: 24.h),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: appColors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 26.w),
                  child: ListView(
                    children: [
                      SizedBox(height: 27.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat.yMMMd()
                                .format(model.currentDate)
                                .toString(),
                            style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: appColors.black),
                          ),
                          SizedBox(
                            width: 79.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(Icons.close)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 23.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          controller.nightStayPresent.isTrue
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                        width: 16.w,
                                        height: 16.h,
                                        child: Obx(
                                          () => Checkbox(
                                            value: controller
                                                .nightStayPerDay.value,
                                            onChanged: (bool? value) {
                                              controller.updateNightStayPerDay(
                                                  value!);
                                              controller.allowanceController
                                                      .text =
                                                  controller.NightStay.value;
                                              if (value) {
                                                controller.NightStay.value =
                                                    controller.nightStayValue;
                                                controller.SameDayReturn.value =
                                                    "0";
                                              } else {
                                                controller.NightStay.value =
                                                    "0";
                                                controller.SameDayReturn.value =
                                                    controller.sameDayReturn;
                                              }
                                              controller.calculateTotal();
                                            },
                                          ),
                                        )),
                                    SizedBox(
                                      width: 7.w,
                                    ),
                                    Obx(
                                      () => Text(
                                        'Night Stay',
                                        style: GoogleFonts.inter(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              controller.nightStayPerDay.isTrue
                                                  ? appColors.black
                                                  : Colors.black26,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(width: 13.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  width: 16.w,
                                  height: 16.h,
                                  child: Obx(
                                    () => Checkbox(
                                      value: controller.isSameDayReturn.value,
                                      onChanged: (bool? value) {
                                        controller.updateSameDayReturn(value!);
                                        if (value) {
                                          controller.SameDayReturn.value =
                                              controller.sameDayReturn;
                                          controller.NightStay.value = "0";
                                        } else {
                                          controller.SameDayReturn.value = "0";
                                          controller.NightStay.value =
                                              controller.nightStayValue;
                                        }
                                        controller.calculateTotal();
                                      },
                                    ),
                                  )),
                              SizedBox(
                                width: 7.w,
                              ),
                              Obx(
                                () => Text(
                                  'Same Day Return',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: controller.isSameDayReturn.isTrue
                                        ? appColors.black
                                        : Colors.black26,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        width: 326.w,
                        decoration: BoxDecoration(
                            color: appColors.white,
                            border: Border.all(
                                color: appColors.borderColor, width: 0.3),
                            borderRadius: BorderRadius.circular(4.0)),
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Obx(
                          () => DropDownTravel(
                            onChange: (v) async {
                              String city = v.cityTo.toString();
                              String km = v.kilometer.toString();
                              controller.travelTo.value = city;
                              controller.travelledKM.value = km;
                              controller.totalAllowance(2);
                              controller.calculateTotal();
                              //logcity);
                              //logkm);
                            },
                            list: controller.distance.value,
                            isExpanded: true,
                            hintName: model.isUpdate.value
                                ? controller.travelTo.value
                                : "Travelled To",
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(height: 13.h),
                      Obx(
                        () => controller.travelTo.value == "Other"
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "or",
                                    style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: appColors.TextHint),
                                  )
                                ],
                              )
                            : Container(),
                      ),
                      SizedBox(height: 15.h),
                      Obx(
                        () => controller.travelTo.value == "Other"
                            ? Container(
                                width: 326.w,
                                height: 50.h,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    color: appColors.white,
                                    border: Border.all(
                                        color: appColors.borderColor,
                                        width: 0.3),
                                    borderRadius: BorderRadius.circular(4.0)),
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    controller: controller.stationTEC,
                                    maxLines: 1,
                                    maxLength: 30,
                                    decoration: const InputDecoration(
                                      counterText: "",
                                      hintText: "Travelled To",
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                      SizedBox(height: 20.h),
                      Obx(
                        () => controller.travelTo.value == "Other" ||
                                model.isUpdate.value
                            ? Container(
                                width: 326.w,
                                height: 50.h,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    color: appColors.white,
                                    border: Border.all(
                                        color: appColors.borderColor,
                                        width: 0.3),
                                    borderRadius: BorderRadius.circular(4.0)),
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    controller: controller.kiloMeterTEC,
                                    maxLines: 1,
                                    maxLength: 30,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText: model.isUpdate.value
                                          ? model.kilometer.toString()
                                          : "Km",
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      controller.travelledKM.value =
                                          value.toString();
                                      controller.totalAllowanceAgain();
                                      controller.calculateTotal();
                                    },
                                  ),
                                ),
                              )
                            : Container(
                                width: 326.w,
                                height: 50.h,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    color: appColors.white,
                                    border: Border.all(
                                        color: appColors.borderColor,
                                        width: 0.3),
                                    borderRadius: BorderRadius.circular(4.0)),
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Text(
                                  controller.travelledKM.value.isEmpty
                                      ? "Km"
                                      : controller.travelledKM.value,
                                  style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: appColors.black),
                                ),
                              ),
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        width: 326.w,
                        height: 50.h,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: appColors.white,
                            border: Border.all(
                                color: appColors.borderColor, width: 0.3),
                            borderRadius: BorderRadius.circular(4.0)),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          controller.fuel_PKm.value.isEmpty
                              ? "Fuel Expense Per Km"
                              : controller.fuel_PKm.value,
                          style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: appColors.black),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        width: 326.w,
                        height: 128.h,
                        decoration: BoxDecoration(
                            color: appColors.white,
                            border: Border.all(
                                color: appColors.borderColor, width: 0.3),
                            borderRadius: BorderRadius.circular(4.0)),
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: TextFormField(
                          controller: controller.NotesController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: model.isUpdate.value
                                ? model.note
                                : "Write Note, if not traveled from base town",
                            hintStyle: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: appColors.TextHint),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Travelled Km",
                              style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: appColors.TextHint),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Obx(
                            () => Container(
                              width: 40.w,
                              alignment: Alignment.centerRight,
                              child: Text(
                                controller.travelledKM.value,
                                style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: appColors.TextHint),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Travel Expenses",
                              style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: appColors.TextHint),
                            ),
                          ),
                          SizedBox(
                            width: 50.w,
                          ),
                          Obx(
                            () => Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                controller.fuel_PKm.value.isEmpty
                                    ? "Fuel Expense Per Km"
                                    : controller.fuel_PKm.value,
                                style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: appColors.TextHint),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      controller.nightStayPerDay.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Night Stay Allowance",
                                    style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: appColors.TextHint),
                                  ),
                                ),
                                SizedBox(
                                  width: 50.w,
                                ),
                                Obx(
                                  () => controller.isEdit.contains('yes')
                                      ? SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: TextField(
                                            controller:
                                                controller.allowanceController,
                                            keyboardType: TextInputType.number,
                                            onChanged: (v) {
                                              if (v.isEmpty) {
                                                controller.allowanceController
                                                    .text = '';
                                                controller.NightStay.value =
                                                    "0";
                                              } else {
                                                controller.NightStay.value =
                                                    v.toString();
                                              }
                                              // controller.calculateNewVal();
                                            },
                                            onEditingComplete: () =>
                                                controller.calculateNewVal,
                                          ),
                                        )
                                      : Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            controller.NightStay.value,
                                            style: GoogleFonts.inter(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: appColors.TextHint),
                                          ),
                                        ),
                                )
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 12.h,
                      ),

                      controller.isSameDayReturn.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Same Day Return",
                                    style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: appColors.TextHint),
                                  ),
                                ),
                                SizedBox(
                                  width: 50.w,
                                ),
                                Obx(
                                  () => controller.isEdit.contains('yes')
                                      ? SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: TextField(
                                            controller:
                                                controller.sameDayController,
                                            keyboardType: TextInputType.number,
                                            onChanged: (v) {
                                              if (v.isEmpty) {
                                                print(v);
                                                controller.sameDayController
                                                    .text = '';
                                                controller.SameDayReturn.value =
                                                    "0";
                                              } else {
                                                controller.SameDayReturn.value =
                                                    v.toString();
                                              }
                                              // controller.calculateNewVal();
                                            },
                                            onEditingComplete: () =>
                                                controller.calculateNewVal,
                                          ),
                                        )
                                      : Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            controller.SameDayReturn.value,
                                            style: GoogleFonts.inter(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: appColors.TextHint),
                                          ),
                                        ),
                                )
                              ],
                            )
                          : Container(),
                      controller.model.travelExpenseData == null ||
                              controller.model.travelExpenseData!.isEmpty
                          ? Container()
                          : Column(
                              children: [
                                // for (var travelItem in controller.expenseList)
                                for (var i = 0;
                                    i <
                                        controller
                                            .model.travelExpenseData!.length;
                                    i++)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: controller.expenseList.isEmpty
                                              ? Container()
                                              : Text(
                                                  controller
                                                          .model
                                                          .travelExpenseData![i]
                                                          .name ??
                                                      'Empty',
                                                  style: GoogleFonts.inter(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          appColors.TextHint),
                                                ),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        controller.expenseList.isEmpty
                                            ? Container()
                                            : controller.expenseList[i].isEdit
                                                    .contains('yes')
                                                ? SizedBox(
                                                    height: 50,
                                                    width: 50,
                                                    child: TextField(
                                                      controller: controller
                                                          .editingControllers[i],
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration: InputDecoration(
                                                          hintText: controller
                                                              .model
                                                              .travelExpenseData![
                                                                  i]
                                                              .value),
                                                      onChanged: (v) {
                                                        if (controller
                                                            .editingControllers[
                                                                i]
                                                            .text
                                                            .isNotEmpty) {
                                                          int value = int.parse(
                                                              controller
                                                                  .editingControllers[
                                                                      i]
                                                                  .text);
                                                          controller
                                                              .expenseList[i]
                                                              .value = value;
                                                          controller
                                                              .calculateNewVal(
                                                                  controller
                                                                      .editingControllers[
                                                                          i]
                                                                      .text);
                                                        }
                                                      },
                                                      onEditingComplete: () =>
                                                          controller
                                                              .calculateNewVal,
                                                    ),
                                                  )
                                                : Container(
                                                    width: 40.w,
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                      formatter.format(
                                                          int.parse(model
                                                              .travelExpenseData![
                                                                  i]
                                                              .value
                                                              .toString())),
                                                      style: GoogleFonts.inter(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: appColors
                                                              .TextHint),
                                                    ),
                                                  )
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                      SizedBox(
                        height: 12.h,
                      ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Container(
                      //       alignment: Alignment.centerRight,
                      //       child: Text(
                      //         "Travelling Daily Allowances",
                      //         style: GoogleFonts.inter(
                      //             fontSize: 12.sp,
                      //             fontWeight: FontWeight.w600,
                      //             color: appColors.TextHint),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 20.w,
                      //     ),
                      //     Obx(
                      //       () => Container(
                      //         width: 40.w,
                      //         alignment: Alignment.centerRight,
                      //         child: Text(
                      //           formatter.format(int.parse(
                      //               controller.TravelDailyAllowance.value)),
                      //           style: GoogleFonts.inter(
                      //               fontSize: 12.sp,
                      //               fontWeight: FontWeight.w600,
                      //               color: appColors.TextHint),
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 12.5.h,
                      // ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 215.5.w,
                            child: Divider(
                              thickness: 2.0,
                              color: appColors.dividerColor,
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: 12.5.h,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Grand Total",
                            style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: appColors.TextHint),
                          ),
                          SizedBox(
                            width: 50.w,
                          ),
                          Obx(
                            () => Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                ((double.parse(controller.travelledKM.value
                                                    .toString()) *
                                                double.parse(controller.fuel_PKm
                                                    .toString())) *
                                            2
                                    +

                                            double.parse(controller
                                                .GrandTotal.value
                                                .toString())

                                )
                                    .toString(),

                                //     .toString(),
                                // controller.GrandTotal.value.toString(),
                                // formatter.format(
                                //     int.parse(controller.GrandTotal.value)),
                                style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: appColors.TextHint),
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        width: 141.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: appColors.gradientColor1,
                        ),
                        child: TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  });
                              String currentDate = DateFormat('yyyy-MM-dd')
                                  .format(model.currentDate);

                              if (model.isUpdate.value) {
                                controller.updateTravelExpense(
                                  context,
                                  currentDate,
                                  model.id!,
                                );
                              } else {
                                controller.submitTravelExpense(
                                  context,
                                  currentDate,
                                );
                              }
                            },
                            child: Text(
                              model.isUpdate.value ? "Update" : "Submit",
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: appColors.white,
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
