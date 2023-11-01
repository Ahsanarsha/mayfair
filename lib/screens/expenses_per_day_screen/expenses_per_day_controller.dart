import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mayfair/data/model/AutoFillMonthHeadQuarterModel.dart';
import 'package:mayfair/data/model/HeadQuarterAllExpenseModel.dart';
import 'package:mayfair/data/model/SingleExpenseByDateModel.dart';
import 'package:mayfair/export.dart';
import 'package:mayfair/screens/expenses_per_day_screen/model/common_model.dart';
import 'package:mayfair/utills/utills.dart';

import '../../data/service/api_client.dart';
import '../head_quarter_expenses_calender/head_quarter_expenses_calender.dart';

class ExpensesPerDayController extends GetxController {
  final api = Get.find<ApiClient>();
  Rx<HeadQuarterAllExpenseModel?>? expenseModel;
  Rx<SingleExpenseByDateModel?>? expenseByDate;

  //
  RxList commonList = <CommonModel>[].obs;
  List<TextEditingController> expenseTC = [];
  List<TextEditingController> expenseNoteTextController = [];
  List<RxBool> controllerError = [];
  List<RxBool> textColorC = [];
  RxList fuelRates = <FuelRates>[].obs;
  List<Map<String, dynamic>> expenesList = [];
  var defaults = [].obs;
  Map<String, dynamic> usedMonthlyExpenses = {};

  //
  var checkedValue = false.obs;
  RxBool _isLoading = false.obs;
  RxBool _expenseLoading = false.obs;
  RxInt total = 0.obs;
  var expenseId = "".obs;
  SingleExpenseByDateModel? monthlyExpensesRemainingAmount;
  var totalChargesAmount = "".obs;
  var fuel_amount = "0".obs;

  RxBool get isLoading => _isLoading;

  //
  set isLoading(RxBool value) {
    _isLoading = value;
    update();
  }

  RxBool get expenseLoading => _expenseLoading;

  set expenseLoading(RxBool value) {
    _expenseLoading = value;
    update();
  }

  getAllExpenseList(String start, String end, String selected_date) async {
    //todo::for the fuel rate
    List<FuelRats> daysList = [];
    int min = 0;
    fuelRates.clear();
    //todo::::::::end

    isLoading = true.obs;
    commonList.clear();
    expenseModel =
        (await api.getHeadQuarterTownExpenseList(start, end, selected_date))
            .obs;
    usedMonthlyExpenses = monthlyValues;
   // expenseModel.value.data.
    expenseModel!.value!.data!.fuelRates!.forEach((value) {
      fuelRates.add(value);
      int days =
          daysBetween(DateTime.parse(selected_date), value.fromdate.toString())
              .abs();
      daysList.add(FuelRats(days, num.parse(value.price!.toString())));
    });

    if (daysList.isNotEmpty) {
      min = daysList[0].days;
      daysList.forEach((e) {
        if (e.days < min) min = e.days;
      });
    }

    //print(min.toString());

    daysList.asMap().forEach((key, value) {
      if (min == value.days) {
        fuel_amount.value = value.rats.toString();
      }
    });

    print("Fuel amount = " + fuel_amount.value);

    expenseModel!.value!.data!.expenseList!.forEach((element) {
      double amountPerKilometer = 0;
      if (element.amountPerKilometer == "yes") {
        amountPerKilometer =
            double.parse(element.value!) * double.parse(fuel_amount.value);
      } else {
        try {
          amountPerKilometer = double.parse(element.value!);
        } catch (error) {
          log(error.toString());
          amountPerKilometer = 0;
        }
      }

      log("Amount pk = $amountPerKilometer");

      String newValue = "0";
      if (element.actualstatus == "Actual") {
        newValue = "1000000000000000";
      } else {
        newValue = element.value ?? "0";
      }

      commonList.add(
        CommonModel(
          element.name!.toString(),
          element.value ?? "0",
          newValue,
          element.type!.toString(),
          element.amountPerKilometer.toString(),
          amountPerKilometer,
          element.actualstatus!,
        ),
      );
      controllerError.add(false.obs);
      textColorC.add(false.obs);
      defaults.add(amountPerKilometer.toString());
      expenseTC.add(TextEditingController());
      expenseNoteTextController.add(TextEditingController());
    });

    defaults.forEach((element) {
      print("value is = ${element}");
    });

    update();
    isLoading = false.obs;
  }

  int daysBetween(DateTime selected, String apiDate) {
    print(apiDate + "  API DATE ");
    DateTime api = DateTime.parse(apiDate);
    selected = DateTime(selected.year, selected.month, selected.day);
    api = DateTime(api.year, api.month, api.day);
    return (api.difference(selected).inHours / 24).round();
  }

  singleDetailByDateList(selectedDay) async {
    String date = DateFormat('yyyy-MM-dd').format(selectedDay);
    isLoading = true.obs;
    commonList.clear();
    expenseByDate = (await api.singleExpenseDetailByDate(date)).obs;

    expenseId.value = expenseByDate!.value!.data![0].id!.toString();

    expenseByDate!.value!.data!.forEach((data) {
      data.expenseId!.forEach((expenseId) {
        String newValue = "0";
        if (expenseId.actualstatus == "Actual") {
          newValue = "100000000000000";
        } else {
          newValue = expenseId.originalValue ?? "0";
        }

        commonList.add(
          CommonModel(
            expenseId.name.toString(),
            expenseId.value ?? "0",
            newValue,
            expenseId.type.toString(),
            expenseId.amount_per_kilometer.toString(),
            0,
            "",
          ),
        );
        controllerError.add(false.obs);
        textColorC.add(false.obs);
        textColorC.add(false.obs);
        defaults.add(expenseId.value);
        expenseTC.add(TextEditingController());
        expenseNoteTextController.add(TextEditingController());
      });
    });
    putDefaultValues(true);

    isLoading = false.obs;
    update();
  }

  addExpense({date}) async {
    expenseLoading = true.obs;
    print('------===');
    log(jsonEncode(expenesList));
    bool result = await api.addExpenseHeadQuarter(data: {
      "current_date": date.toString(),
      "fuel_rate": fuel_amount.value,
      "expense_id": expenesList,
    });
    if (result) {
      expenseLoading = false.obs;
      Get.off(HeadQuarterExpensesCalender(null), binding: Appbindings());
      //log(result.toString());
    } else {
      expenseLoading = false.obs;
    }
  }

  updateExpense({date, id}) async {
    expenseLoading = true.obs;
    bool result = await api.updateExpenseHeadQuarter(data: {
      "id": id.toString(),
      "current_date": date.toString(),
      "expense_id": expenesList,
    });
    if (result) {
      expenseLoading = false.obs;
      Get.off(HeadQuarterExpensesCalender(null), binding: Appbindings());
      //logresult.toString());
    } else {
      expenseLoading = false.obs;
    }
  }


  putDefaultValues(bool b) async {
    usedMonthlyExpenses.forEach((key, value) => print(value));
    if (b) {
      total = 0.obs;
      for (int i = 0; i < expenseTC.length; i++) {
        expenseTC[i].text = defaults[i];
        double one = double.parse(defaults[i]);
        print(one);
        total = total + one.toInt();
      }
    } else {
      for (int i = 0; i < expenseTC.length; i++) {
        expenseTC[i].clear();
      }
      total = 0.obs;
    }
    update();
  }

  putTotalValues(bool b) async {
    total = 0.obs;
    for (int i = 0; i < expenseTC.length; i++) {
      try {
        double one = double.parse(expenseTC[i].text);
        total = total + (one).toInt();
      } catch (error) {
        log("Input Error = "+error.toString());
      }
    }
    //log"Add Total = $total");
    update();
  }
}
