import 'dart:convert';

DashboardTrModel dashboardTrModelFromJson(String source) =>
    DashboardTrModel.fromJson(json.decode(source));

class DashboardTrModel {
  bool? status;
  List<Data>? data;

  DashboardTrModel({this.status, this.data});

  DashboardTrModel.fromJson(Map<String, dynamic> json) {
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
  String? createdAt;
  String? updatedAt;
  String? status;

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
      this.status,
      this.currentDate,
      this.createdAt,
      this.updatedAt});


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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }
}
