import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

class DashboardModel {
  bool? status;
  List<Data>? data;

  DashboardModel({this.status, this.data});

  DashboardModel.fromJson(Map<String, dynamic> json) {
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
  List<ExpenseId>? expenseId;
  String? expenseCategory;
  String? currentDate;
  String? status;
  String? userId;
  String? total;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.expenseCategory,
        this.currentDate,
        this.status,
        this.userId,
        this.total,
        this.expenseId,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['expense_id'] != null) {
      expenseId = <ExpenseId>[];
      jsonDecode(json['expense_id']).forEach((v) {
        expenseId!.add(new ExpenseId.fromJson(v));
      });
    }
    expenseCategory = json['expense_category'];
    currentDate = json['current_date'];
    status = json['status'];
    userId = json['user_id'];
    total = json['total'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}

class ExpenseId {
  String? name;
  String? value;
  String? type;
  String? status;
  int? managerLevel;

  ExpenseId({this.name, this.value, this.type, this.status, this.managerLevel});

  ExpenseId.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
    type = json['type'];
    status = json['status'];
    managerLevel = json['manager_level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    data['type'] = this.type;
    data['status'] = this.status;
    data['manager_level'] = this.managerLevel;
    return data;
  }
}
