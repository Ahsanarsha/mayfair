import 'package:get/get.dart';
import 'package:mayfair/data/base/base_controller.dart';
import 'package:mayfair/data/base/base_url.dart';
import 'package:mayfair/di/export.dart';
import 'package:mayfair/screens/expenses_per_day_screen/model/pass_model.dart';

import '../../data/model/AutoFillMonthHeadQuarterModel.dart';
import '../../data/service/api_client.dart';
import '../../utills/utills.dart';
import '../expenses_per_day_screen/expenses_per_day_screen.dart';

class HeadQuarterExpensesCalenderController extends BaseController {
  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;
  RxList data = [].obs;
  String startDate = "";
  String endDate = "";

  //todo::new code for auto fill
  final api = Get.find<ApiClient>();
  Rx<AutoFillMonthHeadQuarterModel?>? autoFillMonthHeadQuarterModel;
  RxBool _isLoading = false.obs;
  RxBool isClicked = true.obs;
  var total = "0".obs;

  RxBool get isLoading => _isLoading;

  set isLoading(RxBool value) {
    _isLoading = value;
    update();
  }

  @override
  void onInit() {
    getFillMonthHeadQuarterData();
  }

  autoFillMonthHeadQuarterData() async {
    //print("in auto fill of this month api call");
    data = [].obs;
    isLoading = true.obs;
    String startDate = BaseUrls.dateFromHQ.substring(0, 10);
    String endDate = BaseUrls.dateToHQ.substring(0, 10);
    print("Start Date is: $startDate EndDate is: $endDate");
    autoFillMonthHeadQuarterModel = (await api.autoFillMonthHeadQuarterList(startDate, endDate)).obs;
    print("Response::");
    print(autoFillMonthHeadQuarterModel!.value!.data.toString());
    getFillMonthHeadQuarterData();
  }

  getFillMonthHeadQuarterData() async {
    //print("Get Monthly Expense If Exist.");
    data.clear();
    total = "0".obs;
    isLoading = true.obs;
    String startDate = BaseUrls.dateFromHQ.substring(0, 10);
    String endDate = BaseUrls.dateToHQ.substring(0, 10);
    autoFillMonthHeadQuarterModel =
        (await api.getFillMonthHeadQuarterList(startDate, endDate)).obs;
    autoFillMonthHeadQuarterModel!.value!.data!.forEach((value) {
      String expense = "0";
      String status = "";
      value.expenseId!.forEach((element) {
        // if (element.status == 'Added' || element.status == 'Rejected') {
        // } else {
          expense =
              (int.parse(expense) + int.parse(element.value ?? "0")).toString();
          status = element.status.toString();
        // }
        print(status.toString());
      });
      data.value.add(
        {
          "date": value.currentDate,
          'expense': expense,
          'status': status,
          'data_added': true,
        },
      );
      total = (int.parse(total.value) + int.parse(expense)).toString().obs;
      update();
    });
    isLoading = false.obs;
    update();
  }

  checkIfAlreadyFilled(String formattedDate, bool isSubmitted) {
    RxBool isOk = false.obs;
    DataPassModel model;
    RxBool isApproved = false.obs;

    //todo::if already filled
    for (int i = 0; i < data.length; i++) {
      if (data[i]['date'] == formattedDate) {
        isOk = true.obs;
        if (data[i]['status'] == "Approved" ||
            data[i]['status'] == "Rejected") {
          isApproved = true.obs;
          break;
        }
      }
    }

    if (isApproved.value) {
      model = DataPassModel(selectedDay.value, isOk);
      print("Update Expense");
      Get.to(
            () => ExpensesPerDayScreen(startDate, endDate, formattedDate, true),
        binding: Appbindings(),
        arguments: model,
      )!
          .then(
            (value) => getFillMonthHeadQuarterData(),
      );

      return;
    }
    // if(isSubmitted){
    //   showMessage(
    //       title: "Expense", message: "You can't  update submitted expense.");
    //   return;
    // }

    if (isOk.value) {
      model = DataPassModel(selectedDay.value, isOk);
      print("Update Expense");
      Get.to(
        () => ExpensesPerDayScreen(startDate, endDate, formattedDate, isSubmitted),
        binding: Appbindings(),
        arguments: model,
      )!
          .then(
        (value) => getFillMonthHeadQuarterData(),
      );
    } else {
      print("New Expense");
      model = DataPassModel(selectedDay.value, isOk);
      Get.to(
        () => ExpensesPerDayScreen(startDate, endDate, formattedDate,isSubmitted),
        binding: Appbindings(),
        arguments: model,
      )!
          .then(
        (value) => getFillMonthHeadQuarterData(),
      );
    }
  }

  returnDate() {
    return DateTime.parse(startDate);
  }
}
