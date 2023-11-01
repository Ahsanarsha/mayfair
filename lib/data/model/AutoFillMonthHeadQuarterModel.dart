import 'dart:convert';
import 'dart:developer';

AutoFillMonthHeadQuarterModel autoFillMonthHeadQuarterModelFromJson(
        String source) =>
    AutoFillMonthHeadQuarterModel.fromJson(json.decode(source));

class AutoFillMonthHeadQuarterModel {

  bool? status;
  List<Data>? data;

  AutoFillMonthHeadQuarterModel({this.status, this.data});

  AutoFillMonthHeadQuarterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
  String? currentDate;
  List<ExpenseId>? expenseId;

  Data({this.id, this.currentDate, this.expenseId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currentDate = json['current_date'];
    String converted = json['expense_id'].replaceAll(r'\', "");
    dynamic mJson = jsonDecode(converted);
    if (mJson != null) {
      expenseId = [];
      mJson.forEach((v) {
        expenseId?.add(ExpenseId.fromJson(v));
      });
    }
  }
}

class ExpenseId {
  String? name;
  String? value;
  String? orignalValue;
  String? note;
  String? status;

  ExpenseId({
    this.name,
    this.value,
    this.orignalValue,
    this.note,
    this.status,
  });

  ExpenseId.fromJson(dynamic json) {
    name = json['name'];
    value = json['value'];
    orignalValue = json['original_value'];
    note = json['note'];
    status = json['status'];
  }
}
