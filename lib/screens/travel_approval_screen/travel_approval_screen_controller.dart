import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mayfair/data/service/api_client.dart';

import '../../data/base/base_url.dart';
import '../../data/model/AcceptedTravelModel.dart';
import '../../data/model/PendingTravelModel.dart';
import '../../data/model/RejectedTravelModel.dart';
import '../../data/model/SuccessModel.dart';
import '../../utills/utills.dart';

class TravelApprovalsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  var api = Get.find<ApiClient>();
  RxBool _isLoading = true.obs;
  Rx<RejectedTravelModel?>? rejectedModel;
  Rx<AcceptedTravelModel?>? acceptedModel;
  Rx<PendingTravelModel?>? pendingModel;
  Rx<SuccessModel?>? successModel;

  RxList submitList = [].obs;

  var approvedDateFrom = "From".obs;
  var approvedDateTo = "To".obs;

  var rejectedDateFrom = "From".obs;
  var rejectedDateTo = "To".obs;

  var pendingDateFrom = "From".obs;
  var pendingDateTo = "To".obs;

  var acceptedTotal = 0.obs;
  var rejectedTotal = 0.obs;
  var pendingTotal = 0.obs;
  //
  RxBool isChecked = false.obs;
  RxBool selectAll = false.obs;


  RxBool get isLoading => _isLoading;

  set isLoading(RxBool value) {
    _isLoading = value;
    update();
  }

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    getList();
  }

  getList() async {
    String dateFrom = BaseUrls.dateFromTR.substring(0, 10);
    String dateTo = BaseUrls.dateToTR.substring(0, 10);
    log("This is Dashboard Date Not format= ${BaseUrls.dateFromTR},${BaseUrls.dateToTR}");
    log("This is Dashboard Date format= ${dateFrom},${dateTo}");
    await getAcceptedFromTo(dateFrom, dateTo);
    await getRejectedFromTo(dateFrom, dateTo);
    await getPendingFromTo(dateFrom, dateTo);
  }

  submitTravelExpense() async {
    isLoading = true.obs;
    successModel = (await api.submitTravelExpense(submitList)).obs;
    String dateFrom = BaseUrls.dateFromTR.substring(0, 10);
    String dateTo = BaseUrls.dateToTR.substring(0, 10);
    getPendingFromTo(dateFrom, dateTo);
    showMessage(
        title: "Expenses", message: successModel!.value!.message.toString());
    isLoading = false.obs;
  }

  getAcceptedFromTo(String startDate, String endDate) async {
    isLoading = true.obs;
    acceptedModel =
        (await api.getAcceptedListFromToTravel(startDate, endDate)).obs;
    acceptedModel!.value!.data!.forEach((element) {
      acceptedTotal = acceptedTotal + (int.parse(element.grandTotal ?? '0'));
    });
    isLoading = false.obs;
  }

  getRejectedFromTo(String startDate, String endDate) async {
    isLoading = true.obs;
    rejectedModel =
        (await api.getRejectedListFromToTravel(startDate, endDate)).obs;
    rejectedModel!.value!.data!.forEach((element) {
      rejectedTotal = rejectedTotal + (int.parse(element.grandTotal ?? '0'));
    });
    isLoading = false.obs;
  }

  getPendingFromTo(String startDate, String endDate) async {
    pendingTotal = 0.obs;
    isLoading = true.obs;
    pendingModel =
        (await api.getPendingListFromToTravel(startDate, endDate)).obs;
    pendingModel!.value!.data!.forEach((element) {
      pendingTotal = pendingTotal + (int.parse(element.grandTotal ?? '0'));
    });
    isLoading = false.obs;
  }

  approveDateFrom(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      String formatDate = DateFormat('yyyy-MM-dd').format(picked);
      approvedDateFrom = formatDate.obs;
      //logapprovedDateFrom.toString());
      _acceptedCompareDates(
        context,
        approvedDateFrom.toString(),
        approvedDateTo.toString(),
      );
      update();
    }
  }

  approveDateTo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      String formatDate = DateFormat('yyyy-MM-dd').format(picked);
      approvedDateTo = formatDate.obs;
      //logapprovedDateTo.toString());
      _acceptedCompareDates(
        context,
        approvedDateFrom.toString(),
        approvedDateTo.toString(),
      );
      update();
    }
  }

  rejectDateFrom(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      String formatDate = DateFormat('yyyy-MM-dd').format(picked);
      rejectedDateFrom = formatDate.obs;
      //logrejectedDateFrom.toString());
      _rejectedCompareDates(
        context,
        rejectedDateFrom.toString(),
        rejectedDateTo.toString(),
      );
      update();
    }
  }

  rejectDateTo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      String formatDate = DateFormat('yyyy-MM-dd').format(picked);
      rejectedDateTo = formatDate.obs;
      //logrejectedDateTo.toString());
      _rejectedCompareDates(
        context,
        rejectedDateFrom.toString(),
        rejectedDateTo.toString(),
      );
      update();
    }
  }

  pendingsDateFrom(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      String formatDate = DateFormat('yyyy-MM-dd').format(picked);
      pendingDateFrom = formatDate.obs;
      //logrejectedDateFrom.toString());
      _pendingCompareDates(
        context,
        pendingDateFrom.toString(),
        pendingDateTo.toString(),
      );
      update();
    }
  }

  pendingsDateTo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      String formatDate = DateFormat('yyyy-MM-dd').format(picked);
      pendingDateTo = formatDate.obs;
      //logrejectedDateFrom.toString());
      _pendingCompareDates(
        context,
        pendingDateFrom.toString(),
        pendingDateTo.toString(),
      );
      update();
    }
  }

  _acceptedCompareDates(context, String startDate, String endDate) {
    try {
      DateTime dt1 = DateTime.parse(startDate);
      DateTime dt2 = DateTime.parse(endDate);

      if (dt1.compareTo(dt2) == 0) {
        //log"Both date time are at same moment.");
        getAcceptedFromTo(startDate, endDate);
        //log'Filter Accepted List = ${acceptedModel!.value!.data!.length}');
      } else if (dt1.compareTo(dt2) < 0) {
        //log"DT1 is before DT2");
        getAcceptedFromTo(startDate, endDate);
        //log'Filter Accepted List = ${acceptedModel!.value!.data!.length}');
      }

      if (dt1.compareTo(dt2) > 0) {
        //log"DT2 is before DT1");
        Get.snackbar("Invalid!", "End Date is before Start Date");
      }
    } catch (error) {
      //logerror.toString());
    }
  }

  _rejectedCompareDates(context, String startDate, String endDate) {
    try {
      DateTime dt1 = DateTime.parse(startDate);
      DateTime dt2 = DateTime.parse(endDate);

      if (dt1.compareTo(dt2) == 0) {
        //log"Both date time are at same moment.");
        getRejectedFromTo(startDate, endDate);
        //log'Filter Rejected List = ${rejectedModel!.value!.data!.length}');
      } else if (dt1.compareTo(dt2) < 0) {
        //log"DT1 is before DT2");
        getRejectedFromTo(startDate, endDate);
        //log'Filter Rejected List = ${rejectedModel!.value!.data!.length}');
      }

      if (dt1.compareTo(dt2) > 0) {
        //log"DT2 is before DT1");
        Get.snackbar("Invalid!", "End Date is before Start Date");
      }
    } catch (error) {
      //logerror.toString());
    }
  }

  _pendingCompareDates(context, String startDate, String endDate) {
    try {
      DateTime dt1 = DateTime.parse(startDate);
      DateTime dt2 = DateTime.parse(endDate);

      if (dt1.compareTo(dt2) == 0) {
        //log"Both date time are at same moment.");
        getPendingFromTo(startDate, endDate);
        //log'Filter Rejected List = ${rejectedModel!.value!.data!.length}');
      } else if (dt1.compareTo(dt2) < 0) {
        //log"DT1 is before DT2");
        getPendingFromTo(startDate, endDate);
        //log'Filter Rejected List = ${rejectedModel!.value!.data!.length}');
      }

      if (dt1.compareTo(dt2) > 0) {
        //log"DT2 is before DT1");
        Get.snackbar("Invalid!", "End Date is before Start Date");
      }
    } catch (error) {
      //logerror.toString());
    }
  }

  AllChecked(value) {
    if (value) {
      pendingModel!.value!.data!.forEach((element) {
        addSelectedItem(element.id.toString());
      });
    } else {
      submitList.clear();
    }
    update();
  }

   addSelectedItem(String id){
     submitList.value.add(id);
     update();

  }

  removeSelectedItem(String id){
    submitList.value.remove(id);
    update();
  }

  bool isContain(id){
    return submitList.value.contains(id);
  }

}
