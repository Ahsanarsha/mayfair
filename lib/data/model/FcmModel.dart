import 'dart:convert';

FcmModel fcmModelFromJson(String source) =>
    FcmModel.fromJson(json.decode(source));

class FcmModel {
  bool? success;
  Data? data;
  String? message;

  FcmModel({this.success, this.data, this.message});

  FcmModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

}

class Data {
  String? fCMToken;

  Data({this.fCMToken});

  Data.fromJson(Map<String, dynamic> json) {
    fCMToken = json['FCMToken'];
  }

}
