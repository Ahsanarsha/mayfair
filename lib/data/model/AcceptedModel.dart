import 'dart:convert';

AcceptedModel acceptedModelFromJson(String str) =>
    AcceptedModel.fromJson(json.decode(str));

class AcceptedModel {

  bool? status;
  List<Data>? data;

  AcceptedModel({
    this.status,
    this.data,});

  AcceptedModel.fromJson(dynamic json) {
    status = json['Status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

}


class Data {

  int? id;
  List<ExpenseId>? expenseId;
  String? expenseCategory;
  String? currentDate;
  String? status;
  String? userId;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.expenseId,
    this.expenseCategory,
    this.currentDate,
    this.status,
    this.userId,
    this.createdAt,
    this.updatedAt,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    String converted = json['expense_id'].replaceAll(r'\',"");
    dynamic mJson = jsonDecode(converted);
    if (mJson != null) {
      expenseId = [];
      mJson.forEach((v) {
        expenseId?.add(ExpenseId.fromJson(v));
      });
    }
    expenseCategory = json['expense_category'];
    currentDate = json['current_date'];
    status = json['status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }


}

class ExpenseId {

  String? name;
  String? value;
  String? note;
  String? orignalValue;
  String? mNote;
  String? overLimitAmount;

  ExpenseId({
    this.name,
    this.value,
    this.orignalValue,
    this.note,
    this.mNote,
    this.overLimitAmount,
  });

  ExpenseId.fromJson(dynamic json) {
    name = json['name'];
    value = json['value'];
    orignalValue = json['original_value'];
    mNote = json['manager_note'];
    note = json['note'];
    overLimitAmount = json['over_limit_amount'];
  }


}