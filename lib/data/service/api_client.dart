import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:mayfair/data/base/base_url.dart';
import 'package:mayfair/data/model/AcceptedModel.dart';
import 'package:mayfair/data/model/ChangePasswordModel.dart';
import 'package:mayfair/data/model/DashboardModel.dart';
import 'package:mayfair/data/model/GetNotificationModel.dart';
import 'package:mayfair/data/model/HeadQuarterAllExpenseModel.dart';
import 'package:mayfair/data/model/RejectedModel.dart';
import 'package:mayfair/data/model/UserModel.dart';
import 'package:mayfair/data/model/UserProfileModel.dart';
import 'package:mayfair/data/model/app_model.dart';
import 'package:mayfair/export.dart';
import 'package:mayfair/utills/utills.dart';

import '../model/AcceptedTravelModel.dart';
import '../model/AutoFillMonthHeadQuarterModel.dart';
import '../model/DashboardTrModel.dart';
import '../model/FcmModel.dart';
import '../model/GetCalenderModel.dart';
import '../model/GetTravelExpenseByIdModel.dart';
import '../model/PendingModel.dart';
import '../model/PendingTravelModel.dart';
import '../model/RejectedTravelModel.dart';
import '../model/SingleExpenseByDateModel.dart';
import '../model/SuccessModel.dart';
import '../model/TravelExpenseDataModel.dart';

class ApiClient {
  final dio.Dio _dio = dio.Dio();
  AppModel userdata = Get.find();

  Future<UserModel?> login(Map<String, dynamic> data) async {
    try {
      dio.Response response = await _dio.post(BaseUrls.login, data: data);

      if (response.statusCode == 200) {
        if (response.data['success']) {
          // log("RESPONSE " + response.data.toString());

          UserModel userModel = userModelFromJson(json.encode(response.data));
          return userModel;
        } else {
          showMessage(title: "Error", message: response.data['message']);
          return null;
        }
      } else {
        showMessage(title: "Error", message: response.data['message']);
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<bool> logout() async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.post(
        BaseUrls.logout,
      );
      if (response.data['success']) {
        if (response.statusCode == 200) {
          showMessage(title: "", message: response.data['message']);
          return true;
        } else {
          return false;
        }
      } else {
        showMessage(title: "Error", message: response.data['message']);
        return false;
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
      return false;
    }
  }

  Future<UserProfileModel?> userProfile({id}) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.get(
        BaseUrls.userProfile + id,
      );
      log("RESPONSE: " + response.data.toString());
      if (response.data['success']) {
        if (response.statusCode == 200) {
          UserProfileModel userModel =
              userProfileModelFromJson(json.encode(response.data));
          if (!userModel.success!) {
            showMessage(title: "Error", message: userModel.message!);
          }
          return userModel;
        } else {
          UserProfileModel userModel =
              userProfileModelFromJson(json.encode(response.data));
          return userModel;
        }
      } else {
        showMessage(title: "Error", message: response.data['message']);
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<ChangePasswordModel?> changePassword(Map data) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response =
          await _dio.post(BaseUrls.changePassword, data: data);

      if (response.statusCode == 200) {
        // log("RESPONSE ${response.data}");
        if (response.data['Status'] == "Success") {
          ChangePasswordModel changePasswordModel =
              changePasswordModelFromJson(json.encode(response.data));
          // log("MODEL ${changePasswordModel.message.toString()}");

          showMessage(
              title: "Success",
              message: changePasswordModel.message.toString());

          return changePasswordModel;
        } else {
          showMessage(title: "Error", message: response.data['message']);

          return null;
        }
      } else {
        showMessage(title: "Error", message: response.statusMessage.toString());

        return null;
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  uploadImage(File file) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      String fileName = file.path.split('/').last;
      var data = dio.FormData.fromMap({
        "user_id": userdata.userModel!.value!.data!.userId,
        "profile_photo_path": await dio.MultipartFile.fromBytes(
          File(file.path).readAsBytesSync(),
          filename: file.path.split("/").last,
          contentType: MediaType("image", fileName.split(".").last),
        ),
      });
      dio.Response response =
          await _dio.post(BaseUrls.profileUpdate, data: data);

      // log("Response result ${response.data}");
    } on dio.DioError catch (e) {
      // log("EXCEPTION RESULT : ${e.message}");
    }
  }

  Future<DashboardModel?> dashboardHQ(
      {required String startDate, required String endDate}) async {
    String dateStart = startDate.substring(0, 10);
    String dateEnd = endDate.substring(0, 10);

    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.post(BaseUrls.dashboard + "hq", data: {
        'date_start': dateStart.toString(),
        'date_end': dateEnd.toString()
      });
      print("Bilal");
      print(response.data.toString());

      if (response.statusCode == 200) {
        if (response.data['Status']) {
          // log("RESPONSE " + response.data.toString());

          DashboardModel dashboardModel =
              dashboardModelFromJson(json.encode(response.data));
          return dashboardModel;
        } else {
          showMessage(
              title: "Error", message: response.statusMessage.toString());
          return null;
        }
      } else {
        showMessage(title: "Error", message: response.statusMessage.toString());
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<DashboardTrModel?> dashboardTR(
      {required String startDate, required String endDate}) async {
    String dateStart = startDate.substring(0, 10);
    String dateEnd = endDate.substring(0, 10);

    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.post(BaseUrls.dashboard + "tr", data: {
        'date_start': dateStart,
        'date_end': dateEnd,
      });

      print('DATE ------------------------------------------------------------');
      print(dateStart.toString());
      print(dateEnd.toString());

      // log(response.statusCode.toString());

      if (response.statusCode == 200) {
        if (response.data['Status'] == true) {
          // log("RESPONSE " + response.data.toString());

          DashboardTrModel dashboardModel =
              dashboardTrModelFromJson(json.encode(response.data));
          print('------------------DASHBOARD-------------------');
          return dashboardModel;
        } else {
          showMessage(title: "Error", message: "true Something went wrong");
          return null;
        }
      } else {
        showMessage(title: "Error", message: "Something went wrong");
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<HeadQuarterAllExpenseModel?> getHeadQuarterTownExpenseList(
      String start, String end, String selected_date) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.post(BaseUrls.headquarterAllExpenses,
          data: {'selected_date': selected_date});

      dio.Response response2 =
          await _dio.post(BaseUrls.headquarterCheckAllExpenses, data: {
        'start_date': start,
        'end_date': end,
      });
      List<Map<String, dynamic>> masterList = [];
      Map<String, dynamic> map = {};
      //log("NONTHLY EXPENSE DATA> " +response2.data['data'].toString());
      List<dynamic> allItems = response2.data['data']["monthly_expenses"];
      Map<String, dynamic> monthlyValueMap = {};
      (response2.data['data']["expenses_used"] as List).forEach((element) {
        List<Map<String, dynamic>> mainList = [];
        (element["expense_id"].toString().split("},{")).forEach((element2) {
          String temp = (element2
              .replaceAll("[", "")
              .replaceAll("]", "")
              .replaceFirst("{", "")
              .replaceAll("}", "")
              .replaceAll("\"", ""));
          List<String> tempTemp = temp.split(",");
          tempTemp.forEach((tempElement) {
            // log(tempElement.split(":")[0]+":"+tempElement.split(":")[1]);
            map[tempElement.split(":")[0]] = tempElement.split(":")[1];
          });
          mainList.add(map);
          map = {};
        });
        masterList.add({
          "current_date": element["current_date"].toString(),
          "data": mainList,
          "created_at": element["created_at"]
        });
      });
      for (var items in allItems) {
        monthlyValueMap[items["name"]] = 0;
      }
      for (var items in allItems) {
        masterList.forEach((element) {
          for (var mItems in element["data"]) {
            if (mItems["name"] == items["name"]) {
              if (mItems["remaining_amount"] != null)
                monthlyValueMap[items["name"]] += int.parse(mItems["value"]);
            }
          }
        });
      }
      // log(monthlyValueMap.toString()+" MONTHLY_VAL EXP");
      monthlyValues = monthlyValueMap;
      if (response.statusCode == 200) {
        if (response.data['Status']) {
          log("RESPONSE n " + json.encode(response.data).toString());

          HeadQuarterAllExpenseModel headQuarterAllExpenseModel =
              headQuarterAllExpenseModelFromJson(json.encode(response.data));
          return headQuarterAllExpenseModel;
        } else {
          showMessage(
              title: "Error", message: response.statusMessage.toString());
          return null;
        }
      } else {
        showMessage(title: "Error", message: response.statusMessage.toString());
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<RejectedModel?> getRejectedList() async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.get(
        BaseUrls.expensesRejected,
      );

      if (response.statusCode == 200) {
        if (response.data['Status'] == true) {
          // log("RESPONSE " + response.data.toString());

          RejectedModel rejectedModel =
              rejectedModelFromJson(json.encode(response.data));
          return rejectedModel;
        } else {
          showMessage(
              title: "Error", message: response.statusMessage.toString());
          return null;
        }
      } else {
        showMessage(title: "Error", message: response.statusMessage.toString());
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<RejectedModel?> getRejectedListFromTo(
      String startDate, String endDate) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response =
          await _dio.post(BaseUrls.expensesRejectedFromTo, data: {
        'startDate': startDate,
        'endDate': endDate,
      });

      if (response.statusCode == 200) {
        if (response.data['Status'] == true) {
          // log("RESPONSE " + response.data.toString());

          RejectedModel rejectedModel = rejectedModelFromJson(
            json.encode(response.data),
          );
          return rejectedModel;
        } else {
          showMessage(
            title: "Error",
            message: response.statusMessage.toString(),
          );
          return null;
        }
      } else {
        showMessage(
          title: "Error",
          message: response.statusMessage.toString(),
        );
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<AcceptedModel?> getAcceptedList() async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.get(
        BaseUrls.expensesAccepted,
      );

      if (response.statusCode == 200) {
        if (response.data['Status'] == true) {
          // log("RESPONSE " + response.data.toString());

          AcceptedModel acceptedModel =
              acceptedModelFromJson(json.encode(response.data));
          return acceptedModel;
        } else {
          showMessage(
              title: "Error", message: response.statusMessage.toString());
          return null;
        }
      } else {
        showMessage(title: "Error", message: response.statusMessage.toString());
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<AcceptedModel?> getAcceptedListFromTo(
      String startDate, String endDate) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response =
          await _dio.post(BaseUrls.expensesAcceptedFromTo, data: {
        'startDate': startDate,
        'endDate': endDate,
      });
      print("Response of AcceptedList: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data['Status'] == true) {
          // log("RESPONSE " + response.data.toString());

          AcceptedModel acceptedModel = acceptedModelFromJson(
            json.encode(response.data),
          );
          return acceptedModel;
        } else {
          showMessage(
            title: "Error",
            message: response.statusMessage.toString(),
          );
          return null;
        }
      } else {
        showMessage(
          title: "Error",
          message: response.statusMessage.toString(),
        );
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<PendingModel?> getPendingList() async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.get(
        BaseUrls.expensesPending,
      );

      if (response.statusCode == 200) {
        if (response.data['Status'] == true) {
          // log("RESPONSE " + response.data.toString());

          PendingModel pendingModel =
              pendingModelFromJson(json.encode(response.data));
          return pendingModel;
        } else {
          showMessage(
              title: "Error", message: response.statusMessage.toString());
          return null;
        }
      } else {
        showMessage(title: "Error", message: response.statusMessage.toString());
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<PendingModel?> getPendingListFromTo(
      String startDate, String endDate) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response =
          await _dio.post(BaseUrls.expensesPendingFromTo, data: {
        'startDate': startDate,
        'endDate': endDate,
      });

      if (response.statusCode == 200) {
        if (response.data['Status'] == true) {
          // log("RESPONSE " + response.data.toString());

          PendingModel pendingModel = pendingModelFromJson(
            json.encode(response.data),
          );
          return pendingModel;
        } else {
          showMessage(
            title: "Error",
            message: response.statusMessage.toString(),
          );
          return null;
        }
      } else {
        showMessage(
          title: "Error",
          message: response.statusMessage.toString(),
        );
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<bool> addExpenseHeadQuarter({data}) async {
    // log("DATA IS ${data['expense_id']}");
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response =
          await _dio.post(BaseUrls.addExpenseHeadquarter, data: data);
      if (response.statusCode == 200) {
        if (response.data['Status']) {
          // log("RESPONSE " + response.data.toString());
          showMessage(title: "Success", message: response.data['message']);
          return true;
        } else {
          showMessage(
              title: "Error", message: response.statusMessage.toString());
          return false;
        }
      } else {
        showMessage(title: "Error", message: response.statusMessage.toString());
        return false;
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
      return false;
    }
  }

  Future<bool> updateExpenseHeadQuarter({data}) async {
    // log("Update Data is ${data['expense_id']}");
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response =
          await _dio.post(BaseUrls.updateExpenseHeadquarter, data: data);
      if (response.statusCode == 200) {
        if (response.data['Status']) {
          // log("RESPONSE " + response.data.toString());
          showMessage(title: "Success", message: response.data['message']);
          return true;
        } else {
          showMessage(
              title: "Error", message: response.statusMessage.toString());
          return false;
        }
      } else {
        showMessage(title: "Error", message: response.statusMessage.toString());
        return false;
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
      return false;
    }
  }
  Future<List> extraExpenses() async {
    // log("Update Data is ${data['expense_id']}");
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response =
          await _dio.get(BaseUrls.extraExpenses);
      List<dynamic> lists = [];
      lists.addAll(response.data);


      return lists;
      // if (response.statusCode == 200) {
      //   if (response.data['Status']) {
      //     // log("RESPONSE " + response.data.toString());
      //     showMessage(title: "Success", message: response.data['message']);
      //     return response;
      //   } else {
      //     showMessage(
      //         title: "Error", message: response.statusMessage.toString());
      //     return response;
      //   }
      // } else {
      //   showMessage(title: "Error", message: response.statusMessage.toString());
      //   return response;
      // }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
      return [];
    }
  }

  Future<TravelExpenseDataModel?> getExpensesTravelExpenseDataList() async {
    try {
      print("0111");
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.get(
        BaseUrls.expensesTravelExpenseData,
      );

      print("Response: ${response.data}");
      if (response.statusCode == 200) {
        if (response.data['Status']) {
          TravelExpenseDataModel travelExpenseDataModel =
              travelExpenseDataModelFromJson(
            json.encode(response.data),
          );
          return travelExpenseDataModel;
        } else {
          showMessage(
            title: "Error",
            message: response.statusMessage.toString(),
          );
          return null;
        }
      } else {
        showMessage(
          title: "Error",
          message: response.statusMessage.toString(),
        );
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<bool?> submitTravelExpenseList(
    String travelTo,
    String station,
    String kilometer,
    String fuelAmount,
    String amountPkm,
    String samedayReturn,
    String note,
    String grandTotal,
    String currentDate,
    String nightStay,
    List<Map<String, dynamic>> expenesList,
  ) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      print('1');
      print("Printing expenses Before  ${expenesList.toString()}:: ");
      Map<String, dynamic> expenesList2= {};
      String newKey = '';
      String newValue = '';

      //Assign the value to first object


      for (var i = 0; i < expenesList.length; i++) {
        newKey = expenesList[i]['name'].toString();
        newValue = expenesList[i]['value'].toString();

        if (newKey.isNotEmpty && newValue.isNotEmpty) {
          expenesList2[newKey]= newValue;
        }

      }
      expenesList2.putIfAbsent('kilometer', () => kilometer);
      expenesList2.putIfAbsent('fuel_amount', () => fuelAmount);
      expenesList2.putIfAbsent('amount_pkm', () => amountPkm);
      expenesList2.putIfAbsent('sameday_return', () => samedayReturn);
      expenesList2.putIfAbsent('Night_Stay_Allowance', () => nightStay);
      expenesList2.putIfAbsent('grand_total', () => grandTotal);

      print('2');
      expenesList.clear();
      print(jsonEncode({
        'travel_to': travelTo,
        'station': station,
        'kilometer': kilometer,
        'fuel_amount': fuelAmount,
        'amount_pkm': amountPkm,
        'sameday_return': samedayReturn,
        'note': note,
        'grand_total': grandTotal,
        'current_date': currentDate,
        'night_stay': nightStay,
        'expense_data': expenesList2
      }));
      dio.Response response =
          await _dio.post(BaseUrls.expensesSubmitTravelExpense, data: {
        'travel_to': travelTo,
        'station': station,
        'kilometer': kilometer,
        'fuel_amount': fuelAmount,
        'amount_pkm': amountPkm,
        'sameday_return': samedayReturn,
        'note': note,
        'grand_total': grandTotal,
        'current_date': currentDate,
        'night_stay': nightStay,
        'expense_data': expenesList2
      });
      print("Shahzaib response print ${response.data}");

      if (response.statusCode == 200) {
        if (response.data['Status']) {
          showMessage(title: "Success", message: response.data['Message']);
          return true;
        } else {
          showMessage(
              title: "Error", message: response.statusMessage.toString());
          return false;
        }
      } else {
        showMessage(title: "Error", message: response.statusMessage.toString());
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<bool?> updateTravelExpenseList(
    String travelTo,
    String station,
    String kilometer,
    String fuelAmount,
    String amountPkm,
    String samedayReturn,
    String note,
    String grandTotal,
    String currentDate,
    String nightStay,
    String id,
    List<Map<String, dynamic>> expenesList,
  ) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;

      List<Map<String,dynamic>> expenseObjects = [];
      String newKey = '';
      String newValue = '';


      for (var i = 0; i < expenesList.length; i++) {
        newKey = expenesList[i]['name'].toString();
        newValue = expenesList[i]['value'].toString();
        Map<String, dynamic> newObject = {};
        newObject.putIfAbsent('name', () => newKey);
        newObject.putIfAbsent('value', () => newValue);
        newObject.putIfAbsent('status', () => expenesList[i]['status']);
        // print("NewObject before sending: $newObject");
        expenseObjects.add(newObject);
      }
      Map<String, dynamic> kmObject = {};
      Map<String, dynamic> fuelObject = {};
      Map<String, dynamic> amObj = {};
      Map<String, dynamic> sameDObj = {};
      Map<String, dynamic> nsAll = {};
      Map<String, dynamic> gt = {};
      kmObject = {
        'name':'Kilometer',
        'value':kilometer,
        'status':'Added'
      };
      fuelObject = {
        'name':'Fuel amount',
        'value':fuelAmount,
        'status':'Added'
      };
      amObj = {
        'name':'Amount pkm',
        'value':amountPkm,
        'status':'Added'
      };
      sameDObj = {
        'name':'Sameday return',
        'value':samedayReturn,
        'status':'Added'
      };
      nsAll = {
        'name':'Night Stay Allowance',
        'value':nightStay,
        'status':'Added'
      };
      gt = {
        'name':'Grand total',
        'value':grandTotal,
        'status':'Added'
      };
      expenseObjects.add(kmObject);
      expenseObjects.add(fuelObject);
      expenseObjects.add(amObj);
      expenseObjects.add(sameDObj);
      expenseObjects.add(nsAll);
      expenseObjects.add(gt);

      dio.Response response =
          await _dio.post(BaseUrls.expensesUpdateTravelExpense, data: {
        'travel_to': travelTo,
        'station': station,
        'kilometer': kilometer,
        'fuel_amount': fuelAmount,
        'amount_pkm': amountPkm,
        'sameday_return': samedayReturn,
        'note': note,
        'grand_total': grandTotal,
        //'current_date': "${currentDate.toString()}",
        'night_stay': nightStay,
        'id': id,
        'expense_data': expenseObjects
      });
      print("Expense list SHahzaib2 :${response.data}");

      if (response.statusCode == 200) {
        if (response.data['Status']) {
          // log("RESPONSE " + response.data.toString());
          showMessage(title: "Success", message: response.data['Message']);
          return true;
        } else {
          showMessage(
              title: "Error", message: response.statusMessage.toString());
          return false;
        }
      } else {
        showMessage(title: "Error", message: response.statusMessage.toString());
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<AutoFillMonthHeadQuarterModel?> autoFillMonthHeadQuarterList(
    String startDate,
    String endDate,
  ) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response =
          await _dio.post(BaseUrls.autoFillMonthHeadQuarter, data: {
        'start_date': startDate,
        'end_date': endDate,
      });

      if (response.statusCode == 200) {
        if (response.data['status']) {
          // log("RESPONSE " + response.data.toString());

          AutoFillMonthHeadQuarterModel autoFillMonthHeadQuarterModel =
              autoFillMonthHeadQuarterModelFromJson(
            json.encode(response.data),
          );
          return autoFillMonthHeadQuarterModel;
        } else {
          showMessage(
            title: "Error",
            message: response.statusMessage.toString(),
          );
          return null;
        }
      } else {
        showMessage(
          title: "Error",
          message: response.statusMessage.toString(),
        );
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<AutoFillMonthHeadQuarterModel?> getFillMonthHeadQuarterList(
      String startDate, String endDate) async {
    log("This is dates= ${startDate} :: ${endDate}");

    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response =
          await _dio.post(BaseUrls.getFillMonthHeadQuarter, data: {
        'startDate': startDate,
        'endDate': endDate,
      });

      if (response.statusCode == 200) {
        if (response.data['Status']) {
          log("RESPONSE " + response.data.toString());

          AutoFillMonthHeadQuarterModel autoFillMonthHeadQuarterModel =
              autoFillMonthHeadQuarterModelFromJson(
            json.encode(response.data),
          );
          return autoFillMonthHeadQuarterModel;
        } else {
          showMessage(
            title: "Error",
            message: response.statusMessage.toString(),
          );
          return null;
        }
      } else {
        showMessage(
          title: "Error",
          message: response.statusMessage.toString(),
        );
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<SingleExpenseByDateModel?> singleExpenseDetailByDate(
      String date) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response =
          await _dio.post(BaseUrls.singleExpenseByIdHeadQuarter, data: {
        'date': date,
      });
      //log("RESPONSE " + response.data.toString());
      if (response.statusCode == 200) {
        if (response.data['status']) {
          log("RESPONSE " + response.data.toString());

          SingleExpenseByDateModel singleExpenseByDate =
              singleExpenseByDateModelFromJson(
            json.encode(response.data),
          );
          return singleExpenseByDate;
        } else {
          showMessage(
            title: "Error",
            message: response.statusMessage.toString(),
          );
          return null;
        }
      } else {
        showMessage(
          title: "Error",
          message: response.statusMessage.toString(),
        );
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<GetTravelExpenseByIdModel?> getTravelExpenseByID(
      String startDate, String endDate) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response =
          await _dio.post(BaseUrls.getTravelExpenseByID, data: {
        'startDate': startDate,
        'endDate': endDate,
      });
      print("Bilal REwsposen:: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data['Status']) {
          log("RESPONSE " + response.data.toString());

          GetTravelExpenseByIdModel getTravelExpense =
              getTravelExpenseByIdModelFromJson(
            json.encode(response.data),
          );
          return getTravelExpense;
        } else {
          showMessage(
            title: "Error",
            message: response.statusMessage.toString(),
          );
          return null;
        }
      } else {
        showMessage(
          title: "Error",
          message: response.statusMessage.toString(),
        );
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<GetNotificationModel?> getNotificationApi() async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.get(
        BaseUrls.getNotification,
      );

      if (response.statusCode == 200) {
        if (response.data['Status']) {
          log("RESPONSE " + response.data.toString());

          GetNotificationModel getNotificationModel =
              getNotificationModelFromJson(
            json.encode(response.data),
          );
          return getNotificationModel;
        } else {
          showMessage(
            title: "Error",
            message: response.statusMessage.toString(),
          );
          return null;
        }
      } else {
        showMessage(
          title: "Error",
          message: response.statusMessage.toString(),
        );
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<GetCalenderModel?> getCalenderDates() async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.get(BaseUrls.dashboardCalenderDates);

      if (response.statusCode == 200) {
        if (response.data['success']) {
          log("RESPONSE " + response.data.toString());

          GetCalenderModel getCalenderModel =
              getCalenderModelFromJson(json.encode(response.data));
          return getCalenderModel;
        } else {
          showMessage(
              title: "Error", message: response.statusMessage.toString());
          return null;
        }
      } else {
        showMessage(title: "Error", message: response.statusMessage.toString());
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<List<Map<String, dynamic>>> getLastThreeHqExpenseDates() async {
    List<Map<String, dynamic>> myDates = [];
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.get(BaseUrls.lastThreeHqDates);
      if (response.statusCode == 200) {
        // log("RESPONSE " + response.data.toString());
        if (response.data['Status']) {
          for (var items in (response.data['data'] as List)) {
            myDates.add({
              'id': items['id'],
              'date_from': DateTime(
                int.parse(items['date_from'].toString().split('-')[0]),
                int.parse(items['date_from'].toString().split('-')[1]),
                int.parse(items['date_from'].toString().split('-')[2]),
              ),
              'date_to': DateTime(
                int.parse(items['date_to'].toString().split('-')[0]),
                int.parse(items['date_to'].toString().split('-')[1]),
                int.parse(items['date_to'].toString().split('-')[2]),
              ),
            });
          }
          return myDates;
        } else {
          showMessage(
              title: "Error", message: response.statusMessage.toString());
          return myDates;
        }
      } else {
        showMessage(title: "Error", message: response.statusMessage.toString());
        return myDates;
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
      return myDates;
    }
  }

  Future<FcmModel?> postFcmToken(String fcmToken, String email) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.post(BaseUrls.postFcmToken, data: {
        'fcmToken': fcmToken,
        'email': email,
      });
      //log("RESPONSE " + response.data.toString());
      if (response.statusCode == 200) {
        if (response.data['success']) {
          log("RESPONSE " + response.data.toString());

          FcmModel fcmModel = fcmModelFromJson(
            json.encode(response.data),
          );
          return fcmModel;
        } else {
          showMessage(
            title: "Error",
            message: response.statusMessage.toString(),
          );
          return null;
        }
      } else {
        showMessage(
          title: "Error",
          message: response.statusMessage.toString(),
        );
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<AcceptedTravelModel?> getAcceptedListTravel() async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.get(
        BaseUrls.expensesAcceptedTravel,
      );

      if (response.statusCode == 200) {
        if (response.data['Status'] == true) {
          // log("RESPONSE " + response.data.toString());

          AcceptedTravelModel acceptedModel =
              acceptedTravelModelFromJson(json.encode(response.data));
          return acceptedModel;
        } else {
          showMessage(
              title: "Error", message: response.statusMessage.toString());
          return null;
        }
      } else {
        showMessage(title: "Error", message: response.statusMessage.toString());
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<AcceptedTravelModel?> getAcceptedListFromToTravel(
      String startDate, String endDate) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response =
          await _dio.post(BaseUrls.expensesAcceptedFromToTravel, data: {
        'startDate': startDate,
        'endDate': endDate,
      });
      log("BODY " + startDate + " " + endDate);
      if (response.statusCode == 200) {
        if (response.data['Status'] == true) {
          log("RESPONSE " + response.data.toString());

          AcceptedTravelModel acceptedModel = acceptedTravelModelFromJson(
            json.encode(response.data),
          );
          return acceptedModel;
        } else {
          showMessage(
            title: "Error",
            message: response.statusMessage.toString(),
          );
          return null;
        }
      } else {
        showMessage(
          title: "Error",
          message: response.statusMessage.toString(),
        );
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<RejectedTravelModel?> getRejectedListTravel() async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.get(
        BaseUrls.expensesRejectedTravel,
      );

      if (response.statusCode == 200) {
        if (response.data['Status'] == true) {
          // log("RESPONSE " + response.data.toString());

          RejectedTravelModel rejectedModel =
              rejectedTravelModelFromJson(json.encode(response.data));
          return rejectedModel;
        } else {
          showMessage(
              title: "Error", message: response.statusMessage.toString());
          return null;
        }
      } else {
        showMessage(title: "Error", message: response.statusMessage.toString());
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<RejectedTravelModel?> getRejectedListFromToTravel(
      String startDate, String endDate) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response =
          await _dio.post(BaseUrls.expensesRejectedFromToTravel, data: {
        'startDate': startDate,
        'endDate': endDate,
      });

      if (response.statusCode == 200) {
        if (response.data['Status'] == true) {
          // log("RESPONSE " + response.data.toString());

          RejectedTravelModel rejectedModel = rejectedTravelModelFromJson(
            json.encode(response.data),
          );
          return rejectedModel;
        } else {
          showMessage(
            title: "Error",
            message: response.statusMessage.toString(),
          );
          return null;
        }
      } else {
        showMessage(
          title: "Error",
          message: response.statusMessage.toString(),
        );
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<PendingTravelModel?> getPendingListTravel() async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.get(
        BaseUrls.expensesPendingTravel,
      );

      if (response.statusCode == 200) {
        if (response.data['Status'] == true) {
          //log("RESPONSE " + response.data.toString());

          PendingTravelModel pendingModel =
              pendingTravelModelFromJson(json.encode(response.data));
          return pendingModel;
        } else {
          showMessage(
              title: "Error", message: response.statusMessage.toString());
          return null;
        }
      } else {
        showMessage(title: "Error", message: response.statusMessage.toString());
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<PendingTravelModel?> getPendingListFromToTravel(
      String startDate, String endDate) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response =
          await _dio.post(BaseUrls.expensesPendingFromToTravel, data: {
        'startDate': startDate,
        'endDate': endDate,
      });

      if (response.statusCode == 200) {
        if (response.data['Status'] == true) {
          log("RESPONSE " + response.data.toString());

          PendingTravelModel pendingModel = pendingTravelModelFromJson(
            json.encode(response.data),
          );
          return pendingModel;
        } else {
          showMessage(
            title: "Error",
            message: response.statusMessage.toString(),
          );
          return null;
        }
      } else {
        showMessage(
          title: "Error",
          message: response.statusMessage.toString(),
        );
      }
    } on dio.DioError catch (e) {
      showMessage(
          title: "Errors",
          message: e.message!.contains('SocketException: Failed host lookup')
              ? 'Please check your internet connection'
              : e.message);
    }
  }

  Future<SuccessModel?> submitHQExpense(List<dynamic> ids) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response = await _dio.post(BaseUrls.submitHQExpenses, data: {
        'ids': '$ids',
      });

      if (response.statusCode == 200) {
        if (response.data['Status'] == true) {
          // log("RESPONSE " + response.data.toString());
          SuccessModel successModel =
              successModelFromJson(json.encode(response.data));
          return successModel;
          //return null;
        } else {
          showMessage(
            title: "Error",
            message: response.statusMessage.toString(),
          );
          // return null;
        }
      } else {
        showMessage(
          title: "Error",
          message: response.statusMessage.toString(),
        );
      }
    } on dio.DioError catch (e) {
      showMessage(title: "Error in catch", message: e.message);
    }
  }

  Future<SuccessModel?> submitTravelExpense(List<dynamic> ids) async {
    try {
      _dio.options.headers['Authorization'] =
          userdata.userModel!.value!.data!.token;
      dio.Response response =
          await _dio.post(BaseUrls.submitTravelExpenses, data: {
        'ids': '$ids',
      });

      if (response.statusCode == 200) {
        if (response.data['Status'] == true) {
          // log("RESPONSE " + response.data.toString());
          SuccessModel successModel =
              successModelFromJson(json.encode(response.data));
          return successModel;
          //return null;
        } else {
          showMessage(
            title: "Error",
            message: response.statusMessage.toString(),
          );
          // return null;
        }
      } else {
        showMessage(
          title: "Error",
          message: response.statusMessage.toString(),
        );
      }
    } on dio.DioError catch (e) {
      showMessage(title: "Error in catch", message: e.message);
    }
  }
}
