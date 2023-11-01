import 'dart:convert';

SingleExpenseByDateModel singleExpenseByDateModelFromJson(String source) =>
    SingleExpenseByDateModel.fromJson(json.decode(source));

class SingleExpenseByDateModel {

  bool? status;
  List<Data>? data;

  SingleExpenseByDateModel({this.status, this.data});

  SingleExpenseByDateModel.fromJson(Map<String, dynamic> json) {
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
  List<ExpenseId>? expenseId;
  String? expenseCategory;
  String? currentDate;
  String? status;
  String? userId;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.expenseId,
      this.expenseCategory,
      this.currentDate,
      this.status,
      this.userId,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
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
  String? originalValue;
  String? note;
  String? type;
  String? amount_per_kilometer;
  String? actualstatus;
  String? overLimitAmount;
  String? remainingAmount;

  ExpenseId({
    this.name,
    this.value,
    this.originalValue,
    this.note,
    this.type,
    this.amount_per_kilometer,
    this.actualstatus,
    this.overLimitAmount,
    this.remainingAmount,
  });

  ExpenseId.fromJson(dynamic json) {
    name = json['name'];
    value = json['value'];
    originalValue = json['original_value'];
    note = json['note'];
    type = json['type'];
    amount_per_kilometer = json['amount_per_kilometer'];
    actualstatus = json['actualstatus'];
    overLimitAmount = json['over_limit_amount'];
    remainingAmount = json['remaining_amount'];
  }

}
