
import 'dart:convert';

AcceptedTravelModel acceptedTravelModelFromJson(String str) =>
    AcceptedTravelModel.fromJson(json.decode(str));

class AcceptedTravelModel {
  bool? status;
  List<Data>? data;

  AcceptedTravelModel({this.status, this.data});

  AcceptedTravelModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

}

class Data {
  int? id;
  String? userId;
  String? nightStay;
  String? travelTo;
  String? station;
  String? kilometer;
  String? fuelAmount;
  String? note;
  String? grandTotal;
  String? currentDate;
  String? amountPkm;
  String? samedayReturn;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<TravelExpenseData>? travelExpenseData;

  Data(
      {this.id,
        this.userId,
        this.nightStay,
        this.travelTo,
        this.station,
        this.kilometer,
        this.fuelAmount,
        this.note,
        this.grandTotal,
        this.currentDate,
        this.amountPkm,
        this.samedayReturn,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.travelExpenseData});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    nightStay = json['night_stay'];
    travelTo = json['travel_to'];
    station = json['station'];
    kilometer = json['kilometer'];
    fuelAmount = json['fuel_amount'];
    note = json['note'];
    grandTotal = json['grand_total'];
    currentDate = json['current_date'];
    amountPkm = json['amount_pkm'];
    samedayReturn = json['sameday_return'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['expenses'] != null) {
      travelExpenseData = <TravelExpenseData>[];
      json['expenses'].forEach((v) {
        travelExpenseData!.add(new TravelExpenseData.fromJson(v));
      });
    }
  }

}

class TravelExpenseData {
  int? id;
  String? parentId;
  String? mNote;
  String? userId;
  String? name;
  String? value;
  String? status;
  String? createdAt;
  String? updatedAt;

  TravelExpenseData(
      {this.id,
        this.parentId,
        this.userId,
        this.name,
        this.mNote,
        this.value,
        this.status,
        this.createdAt,
        this.updatedAt});

  TravelExpenseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    userId = json['user_id'];
    name = json['name'];
    value = json['value'];
    status = json['status'];
    mNote = json['manager_note'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}