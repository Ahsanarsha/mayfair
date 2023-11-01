import 'dart:convert';

GetCalenderModel getCalenderModelFromJson(String source) =>
    GetCalenderModel.fromJson(json.decode(source));

class GetCalenderModel {
  bool? success;
  Data? data;
  String? message;

  GetCalenderModel({this.success, this.data, this.message});

  GetCalenderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }
}

class Data {
  int? id;
  String? dateTo;
  String? dateFrom;
  String? desc;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.dateTo,
      this.dateFrom,
      this.desc,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateTo = json['date_to'];
    dateFrom = json['date_from'];
    desc = json['desc'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
