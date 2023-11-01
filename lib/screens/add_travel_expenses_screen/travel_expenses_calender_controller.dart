import 'package:get/get.dart';
import 'package:mayfair/data/model/AcceptedModel.dart';
import 'package:mayfair/data/model/GetTravelExpenseByIdModel.dart';

import '../../data/base/base_controller.dart';
import '../../data/base/base_url.dart';
import '../../data/service/api_client.dart';
import '../../di/init_controller.dart';
import 'add_travel_expense_wrt_date.dart';
import 'model/data_pass_model.dart';

class TravelExpensesCalenderController extends BaseController {

  RxBool _isLoading = false.obs;
  final api = Get.find<ApiClient>();
  Rx<GetTravelExpenseByIdModel?>? getTravelExpenseByID;
  var total="0".obs;
  String startDate="";
  String endDate="";

  RxBool get isLoading => _isLoading;

  set isLoading(RxBool value) {
    _isLoading = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getTravelExpenseById();
  }

  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;

  var nightStayVal1 = false.obs;
  var nightStayVal2 = false.obs;
  RxList data = [].obs;




  List<DateTime> calculateDaysInterval(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  getTravelExpenseById() async {
    data.clear();
    total="0".obs;
    isLoading = true.obs;
    print('-------------------------------------------');
    String startDate=BaseUrls.dateFromTR.substring(0,10);
    String endDate=BaseUrls.dateToTR.substring(0,10);
    print("$startDate");
    print("$endDate");
    getTravelExpenseByID = (await api.getTravelExpenseByID(startDate,endDate)).obs;
    getTravelExpenseByID!.value!.data!.forEach((element) {
      print(element.currentDate);
      data.value.add(
        {
          "date": element.currentDate,
          'expense': element.grandTotal,
          'data_added': true,
        },
      );
      total=(double.parse(total.value)+double.parse(element.grandTotal??'0')).toString().obs;
      update();
    });
    isLoading = false.obs;
    print('-------------------------------------------');
    update();
  }



  Future<List> getExtraExpense() async {
    List result = await api.extraExpenses();
    return result;
    print("result of Extra response::: ${result.toString()}");
  }

  checkIfAlreadyFilled(String formattedDate) async{
    List response = await getExtraExpense();
    List<TravelExpenseData> listTravel =[];
    print("My response in check: $response");
   response.forEach((element) {
      TravelExpenseData newObj = TravelExpenseData.fromJson(element);
      listTravel.add(newObj);
      listTravel.forEach((element) {
        print('Ellleeee::: ${element.name} ');
      });
    });
   print("list travel length; ${listTravel.length}");


    // for(int i =0 ;i<=valueLength;i++){
    //   print('yeh');
    //   if(listTravel[i].name == "Kilometer"){
    //     listTravel.remove(listTravel[i]);
    //   }
    //   if(listTravel[i].name == "Fuel amount"){
    //     listTravel.remove(listTravel[i]);
    //   }
    //   if(listTravel[i].name == "Kilometer"){
    //     listTravel.remove(listTravel[i]);
    //   }
    //   if(listTravel[i].name == "Amount pkm"){
    //     listTravel.remove(listTravel[i]);
    //   }
    //   if(listTravel[i].name == "Sameday return"){
    //     listTravel.remove(listTravel[i]);
    //   }
    //   if(listTravel[i].name == "Night Stay Allowance"){
    //     listTravel.remove(listTravel[i]);
    //   }
    //   if(listTravel[i].name == "Grand total"){
    //     listTravel.remove(listTravel[i]);
    //   }
    // }

    List<TravelExpenseData> listTravel2 = [];
    listTravel2.addAll(listTravel);

    listTravel.forEach((element) {
      print("ELEMENT NAME: ${element.name}");

      if(element.name == "Fuel amount"){
       listTravel2.remove(element);
      }
      if(element.name == "Kilometer"){
       listTravel2.remove(element);
      }
      if(element.name == "Amount pkm"){
       listTravel2.remove(element);
      }
      if(element.name == "Same Day Return"){
       listTravel2.remove(element);
      }
      if(element.name == "Night Stay Allowance"){
       listTravel2.remove(element);
      }
      if(element.name == "Grand total"){
        listTravel2.remove(element);
      }

    });

    listTravel2.forEach((element) {
      print("ELementooo:::::${element.name}   ${element.value}");
    });


    RxBool isOk = false.obs;
    //todo::if already filled
    for (int i = 0; i < data.length; i++) {
      if (data[i]['date'] == formattedDate) {
        isOk = true.obs;
      }
    }

    if (isOk.value) {
      Get.snackbar("Already Filled", "Please edit from bottom list");
    } else {
      RxBool isUpdate = false.obs;
      DataPassModel model = DataPassModel(
        "",
        selectedDay.value,
        isUpdate,
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        listTravel2
      );
      Get.to(() => AddTravelExpensesWRTDate(),
          binding: Appbindings(), arguments: model)
          ?.then((value) => getTravelExpenseById());

    }
  }

  returnDate(){
    return DateTime.parse(startDate);
  }

}

