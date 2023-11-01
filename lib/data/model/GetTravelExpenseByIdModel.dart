import 'dart:convert';

GetTravelExpenseByIdModel getTravelExpenseByIdModelFromJson(String source) =>
    GetTravelExpenseByIdModel.fromJson(json.decode(source));

class GetTravelExpenseByIdModel {
  bool? status;
  List<Data>? data;

  GetTravelExpenseByIdModel({this.status, this.data});

  GetTravelExpenseByIdModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  int? id;
  var userId;
  String? nightStay;
  String? travelTo;
  String? station;
  String? status;
  String? kilometer;
  String? fuelAmount;
  String? amountPkm;
  String? SameDayReturn;
  String? note;
  String? grandTotal;
  String? currentDate;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? travelExpenseData;

  Data(
      {this.id,
        this.userId,
        this.nightStay,
        this.travelTo,
        this.station,
        this.status,
        this.kilometer,
        this.fuelAmount,
        this.amountPkm,
        this.SameDayReturn,
        this.note,
        this.grandTotal,
        this.currentDate,
        this.createdAt,
        this.updatedAt,
        this.travelExpenseData
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    nightStay = json['night_stay'];
    status = json['status'];
    travelTo = json['travel_to'];
    station = json['station'];
    kilometer = json['kilometer'];
    amountPkm = json['amount_pkm'];
    SameDayReturn = json['sameday_return'];
    fuelAmount = json['fuel_amount'];
    note = json['note'];
    grandTotal = json['grand_total'];
    currentDate = json['current_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    travelExpenseData = json["travel_expense_data"];

  }
}

class TravelExpenseData {
  int? id;
  String? parentId;
  String? userId;
  String? name;
  String? value;
  Null? note;
  String? managerNote;
  String? status;
  String? managerLevel;
  String? createdAt;
  String? updatedAt;
  String? isEdit;

  TravelExpenseData(
      {this.id,
        this.parentId,
        this.userId,
        this.name,
        this.value,
        this.note,
        this.managerNote,
        this.status,
        this.managerLevel,
        this.createdAt,
        this.isEdit,
        this.updatedAt});

  TravelExpenseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    userId = json['user_id'];
    name = json['name'];
    value = json['value'];
    note = json['note'];
    managerNote = json['manager_note'];
    status = json['status'];
    managerLevel = json['manager_level'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['value'] = this.value;
    data['note'] = this.note;
    data['manager_note'] = this.managerNote;
    data['status'] = this.status;
    data['manager_level'] = this.managerLevel;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
