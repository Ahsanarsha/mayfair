import 'dart:convert';

RejectedModel rejectedModelFromJson(String str) =>
    RejectedModel.fromJson(json.decode(str));

class RejectedModel {
  bool? status;
  List<Rejected>? data;

  RejectedModel({
    this.status,
    this.data,
  });

  RejectedModel.fromJson(dynamic json) {
    status = json['Status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Rejected.fromJson(v));
      });
    }
  }
}

class Rejected {
  int? id;
  List<ExpenseId>? expenseId;
  String? expenseCategory;
  String? currentDate;
  String? status;
  String? userId;
  String? createdAt;
  String? updatedAt;

  Rejected({
    this.id,
    this.expenseId,
    this.expenseCategory,
    this.currentDate,
    this.status,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  Rejected.fromJson(dynamic json) {
    id = json['id'];
    String converted = json['expense_id'].replaceAll(r'\', "");
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
  String? originalValue;
  String? note;
  String? mNote;
  String? overLimitAmount;

  ExpenseId(
      {this.name,
      this.value,
      this.originalValue,
      this.note,
        this.mNote,
      this.overLimitAmount});

  ExpenseId.fromJson(dynamic json) {
    name = json['name'];
    value = json['value'];
    mNote = json['manager_note'];
    originalValue = json['original_value'];
    note = json['note'];
    overLimitAmount = json['over_limit_amount'];
  }
}
