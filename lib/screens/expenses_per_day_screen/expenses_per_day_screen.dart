import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mayfair/export.dart';
import 'package:mayfair/utills/utills.dart';

import '../../widgets/app_bar_with_title.dart';
import 'model/pass_model.dart';

class ExpensesPerDayScreen extends GetView<ExpensesPerDayController> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DataPassModel model = Get.arguments;
  final String startDate;
  final String endDate;
  final bool isSubmitted;
  String selected_date;
  String conditionalDate = "";
  var formatter = NumberFormat('#,##,000');

  ExpensesPerDayScreen(this.startDate, this.endDate, this.selected_date,this.isSubmitted);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpensesPerDayController>(
      initState: (_) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (model.dataAdded.isTrue) {
            controller.singleDetailByDateList(model.date);
             conditionalDate = selected_date.toString();

          } else {
            controller.getAllExpenseList(startDate, endDate, selected_date);
             conditionalDate = selected_date.toString();

          }
        });

      },
      builder: (_) => Scaffold(
        appBar: AppBarWithTitle(
          model.date.toString().substring(0, 10),
          true,
          scaffoldKey: _scaffoldKey,
        ),
        backgroundColor: appColors.white,
        key: _scaffoldKey,
        drawer: const CustomDrawer(),
        drawerScrimColor: appColors.transparent,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: 29.h,
                ),
                getHeadQuartersTownExpensesHeading(),
                SizedBox(
                  height: 15.h,
                ),
                if(!isSubmitted)
                getAutofillBox(),
                SizedBox(
                  height: 14.h,
                ),
                controller.isLoading.value
                    ? Center(
                        child: SpinKitCircle(
                          color: AppColors().gradientColor1,
                        ),
                      )
                    : getData(context),
                SizedBox(
                  height: 15.h,
                ),
                getTotalCharges(),
                SizedBox(
                  height: 24.h,
                ),

                if(!isSubmitted)
                getUpdateButton(context)
              ],
            ),
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

  Widget getAutofillBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 31.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(
            () => Checkbox(
              value: controller.checkedValue.value,
              activeColor: appColors.gradientColor1,
              onChanged: (bool? value) {
                if (controller.checkedValue.isFalse) {
                  //Fetch Default Values
                  controller.checkedValue.value = value!;
                  controller.putDefaultValues(controller.checkedValue.value);
                } else {
                  //Clear Values
                  controller.checkedValue.value = value!;
                  controller.putDefaultValues(controller.checkedValue.value);
                }
              },
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Text(
            appConstants.autoFill,
            style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: appColors.black),
          )
        ],
      ),
    );
  }

  Widget getData(BuildContext context) {
    return Obx(() => Container(
          width: 372.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              color: appColors.grey,
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 3),
                    blurRadius: 6.0,
                    color: Color.fromRGBO(0, 0, 0, 0.04))
              ]),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.w),
            child: Column(
              children: [
                SizedBox(
                  height: 22.h,
                ),
                for (int i = 0; i < controller.commonList.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.commonList[i].name,
                          style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                              color: controller.textColorC[i].value
                                  ? appColors.gradientColor1
                                  : appColors.black),
                        ),
                        Row(
                          children: [
                            Container(
                                width: 88.w,
                                height: 21.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: appColors.borderColor, width: 0.5),
                                  borderRadius: BorderRadius.circular(2.0),
                                  color: appColors.white,
                                ),
                                child: TextFormField(
                                    enabled:
                                        controller.commonList[i].amount_pk ==
                                                "yes"
                                            ? false
                                            : true,
                                    controller: controller.expenseTC[i],
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (newValue) {
                                      //log("On Change $newValue");
                                      if (controller.expenseTC[i].text.isEmpty) {
                                        controller.controllerError[i].value = false;
                                        controller.textColorC[i].value = false;
                                        // controller.AddCharges();
                                      } else {
                                        if (double.parse(controller.expenseTC[i].text) >
                                            double.parse(controller.commonList[i].originalValue)) {
                                          controller.controllerError[i].value = true;
                                          controller.textColorC[i].value = true;
                                          // controller.AddCharges();
                                        } else {
                                          controller.controllerError[i].value = false;
                                          controller.textColorC[i].value = false;
                                          //controller.AddCharges();
                                        }
                                      }
                                      controller.putTotalValues(true);
                                    },
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w400,
                                    ))),
                            SizedBox(
                              width: 18.w,
                            ),
                            InkWell(
                              onTap: (!controller.controllerError[i].value)
                                  ? null
                                  : () {
                                      overLimitNote(context, i);
                                    },
                              splashColor: Colors.black.withOpacity(0.4),
                              splashFactory: InkRipple.splashFactory,
                              child: Image.asset(
                                appAssets.userNotes,
                                width: 20.w,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
        ));
  }

  Widget getTotalCharges() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 31.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(() => Text(
                appConstants.simpleTotal +
                    " : ${formatter.format(controller.total.value)}",
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: appColors.TextHint,
                ),
              )),
          SizedBox(
            width: 15.w,
          ),
          Obx(
            () => SizedBox(
              child: Text(
                controller.totalChargesAmount.value,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getUpdateButton(BuildContext context) {
    return Container(
      width: 292.w,
      height: 52.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.0),
          color: appColors.gradientColor1),
      child: TextButton(
          onPressed: controller.expenseLoading.value
              ? null
              : () {
                  if (controller.commonList.isNotEmpty) {
                    controller.expenesList.clear();
                    for (int i = 0; i < controller.expenseTC.length; i++) {
                      if (controller.expenseTC[i].text.isEmpty) {
                        showMessage(
                            title: "Error",
                            message: controller.commonList[i].name +
                                " field is empty");
                      } else if (controller.controllerError[i].value) {
                        overLimitMessage(context, i);
                      } else {
                        if (model.dataAdded.isTrue) {

                          String text = controller.expenseTC[i].text;
                          String value = double.parse(text).toInt().toString();
                          String originalValue = controller.commonList[i].originalValue;
                          String amount_pk = controller.commonList[i].amount_pk;

                          String exValue = controller.commonList[i].value;
                          String status = controller.commonList[i].actualStatus;
                          String expanseName = controller.commonList[i].name;

                          int overLimit = (int.parse(value) - int.parse(originalValue));
                          int remainingValue = (int.parse(originalValue) - int.parse(value));

                          if (overLimit.isNegative || amount_pk=='yes') {
                            overLimit = 0;
                          }
                          if (remainingValue.isNegative) {
                            remainingValue = 0;
                          }

                          print('Expense Name = $expanseName');
                          print('Actual Status = $status');
                          print('Original Value = $originalValue');
                          print('amount_pk = $amount_pk');
                          print('Text Value = $value');
                          print('API Value = $exValue');
                          print('Over limit = $overLimit');
                          print('-----------------------------');

                          controller.expenesList.add({
                            "name": controller.commonList[i].name.toString(),
                            "value": value,
                            "note": controller.expenseNoteTextController[i].text,
                            'type': controller.commonList[i].type,
                            'original_value': originalValue,
                            'amount_per_kilometer': controller.commonList[i].amount_pk,
                            'over_limit_amount': overLimit.toString(),
                            'remaining_amount': remainingValue.toString(),
                            'manager_level': 0,
                            'actualstatus':
                                controller.commonList[i].actualStatus,
                            'status': "Added",
                          });
                        }
                        else {

                          String text = controller.expenseTC[i].text;
                          String value = double.parse(text).toInt().toString();
                          String originalValue = controller.commonList[i].originalValue;
                          String amount_pk = controller.commonList[i].amount_pk;

                          String exValue = controller.commonList[i].value;
                          String status = controller.commonList[i].actualStatus;
                          String expanseName = controller.commonList[i].name;

                          int overLimit = (double.parse(text).toInt() -
                              double.parse(originalValue).toInt());

                          int remainingValue = (double.parse(controller.commonList[i].originalValue).toInt() -
                              double.parse(controller.expenseTC[i].text).toInt());

                          if (overLimit.isNegative || amount_pk=='yes') {
                            overLimit = 0;
                          }
                          if (remainingValue.isNegative) {
                            remainingValue = 0;
                          }

                          print('Expense Name = $expanseName');
                          print('Actual Status = $status');
                          print('Original Value = $originalValue');
                          print('amount_pk = $amount_pk');
                          print('Text Value = $value');
                          print('API Value = $exValue');
                          print('Over limit = $overLimit');
                          print('-----------------------------');

                          controller.expenesList.add({
                            "name": controller.commonList[i].name.toString(),
                            "value": value,
                            "note": controller.expenseNoteTextController[i].text,
                            'type': controller.commonList[i].type,
                            'original_value': originalValue,
                            'manager_level': 0,
                            'amount_per_kilometer': controller.commonList[i].amount_pk,
                            'over_limit_amount': overLimit.toString(),
                            'remaining_amount': remainingValue.toString(),
                            'actualstatus': controller.commonList[i].actualStatus,
                            'status': "Added",
                          });
                        }
                      }
                    }
                    if (controller.expenesList.length == controller.expenseTC.length) {
                      if (model.dataAdded.isTrue) {
                        controller.updateExpense(
                          date: DateFormat("yyyy-MM-dd").format(model.date),
                          id: controller.expenseId.value,
                        );
                      } else {
                        controller.addExpense(
                          date: DateFormat("yyyy-MM-dd").format(model.date),
                        );
                      }
                    } else {
                      // showMessage(
                      //     title: "Error", message: "Some fields are missing.");
                    }
                  } else {
                    Get.snackbar(
                        "Message", "Head Quarter Expense does not exist.");
                  }
                },
          child: controller.expenseLoading.value
              ? const Center(
                  child: SpinKitCircle(
                    color: Colors.white,
                    size: 25,
                  ),
                )
              : Text(
                  "Update",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: appColors.white,
                  ),
                )),
    );
  }

  overLimitMessage(BuildContext context, int i) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: appColors.white.withOpacity(0.85),
      builder: (BuildContext mContext) {
        return AlertDialog(
          backgroundColor: const Color(0XFFF8F8F8),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.30,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Over Limit Expense Entry",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.close,
                        ),
                      ),
                    ]),
                Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "You are exceeding the designated amount",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ]),
                    const SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "You must have note for over-limit?",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ]),
                    const SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Do you want to continue?",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ]),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            overLimitNote(context, i);

                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: appColors.gradientColor1,
                            ),
                          )),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            color: appColors.gradientColor1),
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "NO",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: appColors.white,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  overLimitNote(BuildContext context, int i) {
    Size size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: appColors.white.withOpacity(0.85),
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: const Color(0XFFF8F8F8),
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: size.width,
              height: size.height * 0.40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 18.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Over Limit Expense Note",
                          style: getTextStyle(
                            16,
                            FontWeight.w700,
                            appColors.black,
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
                    padding: EdgeInsets.only(left: 22.w, right: 24.w),
                    child: Container(
                      width: 328.w,
                      height: 147.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                        color: appColors.white,
                      ),
                      child: TextFormField(
                        maxLines: null,
                        minLines: null,
                        expands: true,
                        controller: controller.expenseNoteTextController[i],
                        style: getTextStyle(
                          14,
                          FontWeight.w400,
                          appColors.black,
                        ),
                      ),
                    ),
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
                          borderRadius: BorderRadius.circular(2.0),
                          color: appColors.gradientColor1,
                        ),
                        child: TextButton(
                          onPressed: () {
                            Get.back();
                            Get.snackbar('Success',
                                'Added ${controller.commonList[i].name} Notes');
                            controller.controllerError[i].value = false;
                            controller.update();
                          },
                          child: Text(
                            "Submit",
                            style: getTextStyle(
                                14, FontWeight.w600, appColors.white),
                          ),
                        )),
                  )
                ],
              ),
            ));
      },
    );
  }

  TextStyle getTextStyle(
    double fSize,
    FontWeight weight,
    Color color,
  ) {
    TextStyle style = GoogleFonts.inter(
      fontSize: fSize.sp,
      fontWeight: weight,
      color: color,
    );
    return style;
  }
}
