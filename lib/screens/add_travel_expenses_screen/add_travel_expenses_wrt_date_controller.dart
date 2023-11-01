import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mayfair/utills/utills.dart';

import '../../data/model/TravelExpenseDataModel.dart';
import '../../data/service/api_client.dart';
import 'model/data_pass_model.dart';

class TravelExpensesWRTDateController extends GetxController {
  var nightStayPerDay = false.obs;
  RxBool nightStayPresent = false.obs;
  RxBool isSameDayReturn = false.obs;
  RxBool _isLoading = true.obs;
  String nightStayValue = '0';
  String sameDayReturn = '0';
  final api = Get.find<ApiClient>();
  RxString isEdit = "no".obs;
  Rx<TravelExpenseDataModel?>? travelExpenseDataModel;
  late DataPassModel model;
  var stationTEC = TextEditingController();
  var kiloMeterTEC = TextEditingController();
  var fuelExpensePerKMTEC = TextEditingController();
  int travelItemsExpenses = 0;

  RxBool get isLoading => _isLoading;
  List<Expense> expenseList = [];
  List<Map<String, dynamic>> expenesList = [];

  set isLoading(RxBool value) {
    _isLoading = value;
    update();
  }

  //todo::for drop down list
  RxList distance = <Distance>[].obs;
  RxList fuelRates = <FuelRates>[].obs;

  //todo::submit value for API
  var travelTo = "".obs;
  var travelledKM = "0".obs;
  var fuel_amount = "0".obs;
  var fuel_PKm = "0".obs;
  var travelExpenses = "0".obs;
  var NightStay = "0".obs;
  var SameDayReturn = "0".obs;

  //var TravelDailyAllowance = "0".obs;
  var GrandTotal = "0".obs;

  //todo::EditText Controller
  var NotesController = TextEditingController();
  var allowanceController = TextEditingController();
  var sameDayController = TextEditingController();
  List<TextEditingController> editingControllers = [];

  updateNightStayPerDay(bool value) {
    nightStayPerDay.value = value;
    isSameDayReturn.value = !value;
    update();
  }

  updateSameDayReturn(bool value) {
    isSameDayReturn.value = value;
    nightStayPerDay.value = !value;
    update();
  }

  totalAllowance(int multiply) {
    // int finalValue = (int.parse(travelledKM.value) * int.parse(fuel_amount.value));
    double finalValue =
        (double.parse(travelledKM.value) * double.parse(fuel_PKm.value)) * multiply;
    travelExpenses.value = finalValue.toString();
  }

  calculateTotal() {
    int nightStay = 0;
    int sameDayReturn = 0;
    double travelExpense =
        (travelExpenses.value == "") ? 0 : double.parse(travelExpenses.value);

    if (nightStayPerDay.value) {
      nightStay = (NightStay.value == "") ? 0 : int.parse(NightStay.value);
      allowanceController.text = nightStay.toString();
    }
    if (isSameDayReturn.value) {
      sameDayReturn =
          (SameDayReturn.value == "") ? 0 : int.parse(SameDayReturn.value);
      sameDayController.text = sameDayReturn.toString();
    }

    // int dailyAllowance = (TravelDailyAllowance.value == "")
    //     ? 0
    //     : int.parse(TravelDailyAllowance.value);
    travelItemsExpenses = 0;
    // expenseList.forEach((element) {
    //
    //   travelItemsExpenses += element.value;
    // });
    model.travelExpenseData!.forEach((element) {

      travelItemsExpenses += int.parse(element.value.toString());
    });
    double grandTotal =
        travelExpense + nightStay + travelItemsExpenses + sameDayReturn;

    print("Values are ${travelExpense.toString()}  ${nightStay.toString()}  ${travelItemsExpenses.toString()}  ${sameDayReturn.toString()}}");
    GrandTotal.value = grandTotal.toString();
  }

  calculateNewVal(String val) {
    int nightStay = 0;
    int sameDayReturn = 0;
    int travelExpense =
        (travelExpenses.value == "") ? 0 : int.parse(travelExpenses.value);
    //int newValueAsList = (val == "") ? 0 : int.parse(val);

    if (nightStayPerDay.value) {
      nightStay = (NightStay.value == "")
          ? 0
          : int.parse(allowanceController.text.isEmpty
              ? '0'
              : allowanceController.text);
      // allowanceController.text = nightStay.toString();
    }
    if (isSameDayReturn.value) {
      sameDayReturn = (SameDayReturn.value == "")
          ? 0
          : int.parse(
              sameDayController.text.isEmpty ? '0' : sameDayController.text);
    }
    if (val.isNotEmpty) {
      travelItemsExpenses = 0;
      expenseList.forEach((element) {
        travelItemsExpenses += element.value;
      });
      GrandTotal.value = '';
      int grandTotal =
          travelExpense + nightStay + sameDayReturn + travelItemsExpenses;
      GrandTotal.value = grandTotal.toString();
    } else {
      GrandTotal.value = '';
      int grandTotal = 0;
      GrandTotal.value = grandTotal.toString();
    }
  }

  totalAllowanceAgain() {
    //int finalValue = (int.parse(kiloMeterTEC.text) * int.parse(fuel_amount.value));
    int finalValue =
        (int.parse(kiloMeterTEC.text) * int.parse(fuel_PKm.value)) * 2;
    travelExpenses.value = finalValue.toString();
  }

  getTravelExpenseData() async {
  print("012312123");
    //todo::for the fuel rate
    List<FuelRats> daysList = [];
    int min = 0;
    //todo::::::::end

    isLoading = true.obs;
    distance.clear();
    fuelRates.clear();
    print("here");
    travelExpenseDataModel = (await api.getExpensesTravelExpenseDataList()).obs;
    travelExpenseDataModel!.value!.data!.cityTo!.forEach((value) {
      distance.add(value);
    });
    isEdit = travelExpenseDataModel!.value!.data!.isEdit.toString().obs;
    allowanceController.text = NightStay.value;
    distance.add(Distance(
      cityTo: "Other",
      kilometer: "0",
      createdAt: "",
      updatedAt: "",
    ));

    try {
      fuel_PKm.value = travelExpenseDataModel!.value!.data!.fuelPKM![0].price!;
      update();
    } catch (error) {
      fuel_PKm.value = "0";
    }

    travelExpenseDataModel!.value!.data!.fuelRates!.forEach((value) {
      fuelRates.add(value);
      int days =
          daysBetween(model.currentDate, value.dateFrom.toString()).abs();
      daysList.add(FuelRats(days, num.parse(value.price!)));
    });
    travelExpenseDataModel!.value!.data!.travelExpense!.forEach((value) {
      editingControllers.add(TextEditingController());
      String kemat = value.value!.isEmpty || value.value == null
          ? "0"
          : value.value.toString();
      int addedValue = int.parse(kemat);
      if (value.name!.contains("Same Day Return")) {
        sameDayReturn = value.value!;
        addedValue = 0;

      } else if (value.name!.contains("Night Stay Allowance")) {
        nightStayPresent = true.obs;
        nightStayValue = value.value!;
        addedValue = 0;

      } else if (value.name!.contains("Travelling")) {
        addedValue = 0;

      } else {
        expenseList.add(Expense(value.name!, int.parse(kemat), value.isEdit!));
       // editingControllers[expenseList.length - 1].text = kemat.toString();
        travelItemsExpenses += addedValue;
      }
    });

    if (daysList.isNotEmpty) {
      min = daysList[0].days;
      daysList.forEach((e) {
        if (e.days < min) min = e.days;
      });
    }
    daysList.asMap().forEach((key, value) {
      if (min == value.days) {
        fuel_amount.value = value.rats.toString();
      }
    });
    calculateTotal();
    isLoading = false.obs;
    update();
  }

  int daysBetween(DateTime selected, String apiDate) {
    DateTime api = DateTime.parse(apiDate);
    selected = DateTime(selected.year, selected.month, selected.day);
    api = DateTime(api.year, api.month, api.day);
    return (api.difference(selected).inHours / 24).round();
  }

  submitTravelExpense(BuildContext context, currentDate) async {
    expenesList.clear();
    expenseList.forEach((element) {
      expenesList.add({
        "name": element.name,
        "value": element.value,
        'status': "Added",
      });
    });

    bool? result = await api.submitTravelExpenseList(
      travelTo.value == "Other" ? stationTEC.text : travelTo.value,
      "",
      travelledKM.value,
      fuel_amount.value,
      fuel_PKm.value,
      SameDayReturn.value,
      NotesController.text,
      // GrandTotal.value,
      ((double.parse(travelledKM.value
          .toString()) *
          double.parse(fuel_PKm
              .toString())) *
          2
          +

          double.parse(GrandTotal.value
              .toString())

      ).toString(),
      currentDate,
      NightStay.value,
      expenesList,
    );
    if (result!) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }

    // if (!expenesList.isEmpty) {
    //
    // } else {
    //   showMessage(
    //     title: "Travel Expense!",
    //     message: "Admin not added expense.",
    //   );
    // }
  }

  updateTravelExpense(
      BuildContext context, String currentDate, String id) async {
    expenesList.clear();
    expenseList.forEach((element) {
      expenesList.add({
        "name": element.name,
        "value": element.value,
        'status': "Added",
      });
    });

    bool? result = await api.updateTravelExpenseList(
        travelTo.value == "Other" ? stationTEC.text.toString() : travelTo.value,
        "",
        travelledKM.value,
        fuel_amount.value,
        fuel_PKm.value,
        SameDayReturn.value,
        NotesController.text,
        GrandTotal.value,
        currentDate,
        NightStay.value,
        id,
        expenesList);
    if (result!) {
      Navigator.of(context).pop();
    }
  }
}

class FuelRats {
  int days;
  num rats;

  FuelRats(this.days, this.rats);
}

class Expense {
  String name;
  int value;
  String isEdit;

  Expense(this.name, this.value, this.isEdit);
}
