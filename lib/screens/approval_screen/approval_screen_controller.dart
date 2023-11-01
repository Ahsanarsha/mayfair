import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mayfair/data/model/AcceptedModel.dart';
import 'package:mayfair/data/model/RejectedModel.dart';
import 'package:mayfair/data/service/api_client.dart';
import 'package:mayfair/utills/utills.dart';

import '../../data/base/base_url.dart';
import '../../data/model/PendingModel.dart';
import '../../data/model/SuccessModel.dart';

class ApprovalsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //
  late TabController tabController;
  var api = Get.find<ApiClient>();

  //
  Rx<RejectedModel?>? rejectedModel;
  Rx<AcceptedModel?>? acceptedModel;
  Rx<PendingModel?>? pendingModel;
  Rx<SuccessModel?>? successModel;

  //
  var approvedDateFrom = "From".obs;
  var approvedDateTo = "To".obs;

  //
  var rejectedDateFrom = "From".obs;
  var rejectedDateTo = "To".obs;

  //
  var pendingDateFrom = "From".obs;
  var pendingDateTo = "To".obs;

  //
  var acceptedTotal = 0.obs;
  var rejectedTotal = 0.obs;
  var pendingTotal = 0.obs;

  //
  RxList submitList = [].obs;
  RxBool isChecked = false.obs;
  RxBool selectAll = false.obs;

  //
  RxBool _isLoading = true.obs;

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

  submitHQexpense() async {
    isLoading = true.obs;
    successModel = (await api.submitHQExpense(submitList)).obs;
    String dateFrom = BaseUrls.dateFromHQ.substring(0, 10);
    String dateTo = BaseUrls.dateToHQ.substring(0, 10);
    await getPendingFromTo(dateFrom, dateTo);
    showMessage(
        title: "Expenses", message: successModel!.value!.message.toString());
    isLoading = false.obs;
  }

  getList() async {
    // await getAccepted();
    // await getRejected();
    // await getPending();
    String dateFrom = BaseUrls.dateFromHQ.substring(0, 10);
    String dateTo = BaseUrls.dateToHQ.substring(0, 10);

    await getAcceptedFromTo(dateFrom, dateTo);
    await getRejectedFromTo(dateFrom, dateTo);
    await getPendingFromTo(dateFrom, dateTo);
  }

  getAccepted() async {
    acceptedModel = (await api.getAcceptedList()).obs;
    acceptedModel!.value!.data!.forEach((element) {
      element.expenseId!.forEach((element) {
        acceptedTotal = acceptedTotal + (int.parse(element.value!));
      });
    });
    //log'Accepted Total =$acceptedTotal');
  }

  getRejected() async {
    rejectedModel = (await api.getRejectedList()).obs;
    rejectedModel!.value!.data!.forEach((element) {
      element.expenseId!.forEach((element) {
        rejectedTotal = rejectedTotal + (int.parse(element.value!));
      });
    });
    //log'Rejected Total =$rejectedTotal');
    isLoading = false.obs;
  }

  getPending() async {
    pendingModel = (await api.getPendingList()).obs;
    pendingModel!.value!.data!.forEach((element) {
      element.expenseId!.forEach((element) {
        pendingTotal = pendingTotal + (int.parse(element.value!));
      });
    });
    //log'Rejected Total =$rejectedTotal');
    isLoading = false.obs;
  }

  getAcceptedFromTo(String startDate, String endDate) async {
    acceptedTotal = 0.obs;
    isLoading = true.obs;
    acceptedModel = (await api.getAcceptedListFromTo(startDate, endDate)).obs;
    acceptedModel!.value!.data!.forEach((element) {
      element.expenseId!.forEach((element) {
        acceptedTotal = acceptedTotal + (int.parse(element.value!));
      });
    });
    isLoading = false.obs;
  }

  getRejectedFromTo(String startDate, String endDate) async {
    rejectedTotal = 0.obs;
    isLoading = true.obs;
    rejectedModel = (await api.getRejectedListFromTo(startDate, endDate)).obs;
    rejectedModel!.value!.data!.forEach((element) {
      element.expenseId!.forEach((element) {
        rejectedTotal = rejectedTotal + (int.parse(element.value!));
      });
    });
    isLoading = false.obs;
  }

  getPendingFromTo(String startDate, String endDate) async {
    pendingTotal = 0.obs;
    isLoading = true.obs;
    pendingModel = (await api.getPendingListFromTo(startDate, endDate)).obs;
    pendingModel!.value!.data!.forEach((element) {
      element.expenseId!.forEach((element) {
        pendingTotal = pendingTotal + (int.parse(element.value!));
      });
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

  _acceptedCompareDates(
      BuildContext context, String startDate, String endDate) {
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

  _rejectedCompareDates(
      BuildContext context, String startDate, String endDate) {
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

  _pendingCompareDates(BuildContext context, String startDate, String endDate) {
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
    print(submitList);
    update();
  }

  addSelectedItem(String id) {
    submitList.value.add(id);
    print(submitList);
    update();
  }

  removeSelectedItem(String id) {
    submitList.value.remove(id);
    print(submitList);
    update();
  }

  bool isContain(id) {
    return submitList.value.contains(id);
  }
}
