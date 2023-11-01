import 'dart:convert';

SuccessModel successModelFromJson(String str) =>
    SuccessModel.fromJson(json.decode(str));

class SuccessModel {
  bool? status;
  String? message;

  SuccessModel({this.status, this.message});

  SuccessModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}