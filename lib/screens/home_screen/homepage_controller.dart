import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mayfair/data/base/base_url.dart';
import 'package:mayfair/data/model/DashboardModel.dart';
import 'package:mayfair/data/model/app_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/DashboardTrModel.dart';
import '../../data/model/GetCalenderModel.dart';
import '../../data/service/api_client.dart';

class HomeController extends GetxController {
  AppModel userdata = Get.find();
  final api = Get.find<ApiClient>();

  var profileData = Get.find<AppModel>().userProfileModel;
  Rx<GetCalenderModel?>? getCalenderModel;
  Rx<double> totalHeadQuarterExpense = 0.0.obs;
  Rx<double> totalHqAddedExpense = 0.0.obs;
  RxInt totalTravelExpense = 0.obs;
  Rx<double> totalTravelAddedExpense = 0.0.obs;
  RxInt grandTotal = 0.obs;
  RxBool isLoading=true.obs;

  List<Map<String, dynamic>> hqExpenseDates = [];
  List<Map<String, dynamic>> travelExpenseDates = [];
  Map<String, dynamic> hqExpenseDate = {};
  Map<String, dynamic> travelExpenseDate = {};

  DateTime? selectedDate;

  @override
  void onInit() {
    BaseUrls.fromUser=profileData!.value!.data!.baseTown??"";
    super.onInit();
  }


  saveDate(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("DateIndex", index);
    print('SAVING EXPENSE INDEX => ${index}');
    getLastThreeAddedHQExpenseDates();
  }


  getLastThreeAddedHQExpenseDates() async {

    hqExpenseDates = (await api.getLastThreeHqExpenseDates()).obs;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? expensesDateIndex = await prefs.getInt("DateIndex");
      if (expensesDateIndex != null) {
        print('INDEX FROM SHARED PREFS OF DATE => ${expensesDateIndex}');
        hqExpenseDate = hqExpenseDates[expensesDateIndex];
        travelExpenseDates = hqExpenseDates;
        travelExpenseDate = hqExpenseDates[expensesDateIndex];
        getCalanderDates(
          hqExpenseDate["date_from"].toString(),
          hqExpenseDate["date_to"].toString(),
          travelExpenseDate["date_from"].toString(),
          travelExpenseDate["date_to"].toString(),
        );
        BaseUrls.dateFromHQ = hqExpenseDate["date_from"].toString();
        BaseUrls.dateToHQ = hqExpenseDate["date_to"].toString();
        //Travel Date
        BaseUrls.dateFromTR = hqExpenseDate["date_from"].toString();
        BaseUrls.dateToTR = hqExpenseDate["date_to"].toString();
      } else {
        print('PREFS ARE NULL');
        hqExpenseDate = hqExpenseDates[0];
        travelExpenseDates = hqExpenseDates;
        travelExpenseDate = hqExpenseDates[0];
        getCalanderDates(
          hqExpenseDate["date_from"].toString(),
          hqExpenseDate["date_to"].toString(),
          travelExpenseDate["date_from"].toString(),
          travelExpenseDate["date_to"].toString(),
        );
        BaseUrls.dateFromHQ = hqExpenseDate["date_from"].toString();
        BaseUrls.dateToHQ = hqExpenseDate["date_to"].toString();
        //Travel Date
        BaseUrls.dateFromTR = hqExpenseDate["date_from"].toString();
        BaseUrls.dateToTR = hqExpenseDate["date_to"].toString();
      }
      isLoading.value=false;
      update();
    } catch (error) {
      print('ERROR FETCHING DATES INDEX => ${error.toString()}');
    }
    //update();
  }
  RxInt addedNotSub = 0.obs;
  getDashBoardHQData({required startDate, required endDate}) async {
    totalHeadQuarterExpense = 0.0.obs;
    addedNotSub = 0.obs;
    DashboardModel? model =
        await api.dashboardHQ(startDate: startDate, endDate: endDate);

    if (model != null) {

      model.data!.forEach((element) {
        if(element.status == 'Added'){
          addedNotSub += int.parse(element.total!);
        }
      });
      model.data!.forEach((element) {
       element.expenseId!.forEach((elementt){
         if(elementt.status == 'Approved'){
           print("totalHeadQuarter::::: Name: ${elementt.name}  Value: ${elementt.value}");
           totalHeadQuarterExpense += double.parse(elementt.value!);
           update();
         }
         else if (elementt.status == 'Added'){
           totalHqAddedExpense += double.parse(elementt.value!);
           update();
         }
         else{
           print("Otherss::::: Name: ${elementt.name}  Value: ${elementt.value}  Status: ${element.status}");
         }
       });




      });
    }
  }


  getDashBoardTrData({required startDate, required endDate}) async {
    totalTravelExpense = 0.obs;
    totalTravelAddedExpense = 0.0.obs;
    DashboardTrModel? model = await api.dashboardTR(
      startDate: startDate,
      endDate: endDate,
    );
    if (model != null) {
      model.data!.forEach((element) {
        if (element.status == 'Added') {
          totalTravelAddedExpense += double.parse(element.grandTotal ?? "0.0");
        }
        else if ( element.status == 'Rejected') {
        }
        else if ( element.status == 'Approved') {
          totalTravelExpense += int.parse(element.grandTotal ?? "0");
          update();
        }
        else {

        }
      });
    }
  }

  getCalanderDates(
    String dateFromHQ,
    String dateToHQ,
    String dateFromTravel,
    String dateToTravel,
  ) async {
    profileData = (await api.userProfile(
            id: userdata.userModel!.value!.data!.userId.toString()))
        .obs;
    update();

    try {
      getDashBoardHQData(startDate: dateFromHQ, endDate: dateToHQ);
      getDashBoardTrData(startDate: dateFromTravel, endDate: dateToTravel);
    } catch (error) {
      log(error.toString());
    }
  }

}
