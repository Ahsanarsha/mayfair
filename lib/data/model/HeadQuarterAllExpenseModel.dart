import 'dart:convert';

HeadQuarterAllExpenseModel headQuarterAllExpenseModelFromJson(String str) =>
    HeadQuarterAllExpenseModel.fromJson(json.decode(str));

class HeadQuarterAllExpenseModel {
  bool? status;
  Data? data;

  HeadQuarterAllExpenseModel({this.status, this.data});

  HeadQuarterAllExpenseModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

}

class Data {
  List<FuelRates>? fuelRates;
  List<ExpenseList>? expenseList;

  Data({this.fuelRates, this.expenseList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['fuel_rates'] != null) {
      fuelRates = <FuelRates>[];
      json['fuel_rates'].forEach((v) {
        fuelRates!.add(FuelRates.fromJson(v));
      });
    }
    if (json['expense_list'] != null) {
      expenseList = <ExpenseList>[];
      json['expense_list'].forEach((v) {
        expenseList!.add(ExpenseList.fromJson(v));
      });
    }
  }

}

class FuelRates {
  int? id;
  String? price;
  String? fromdate;
  String? todate;
  String? createdAt;
  String? updatedAt;

  FuelRates(
      {this.id,
        this.price,
        this.fromdate,
        this.todate,
        this.createdAt,
        this.updatedAt});

  FuelRates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    fromdate = json['fromdate'];
    todate = json['todate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}

class ExpenseList {
  int? id;
  String? role;
  String? name;
  String? value;
  String? type;
  String? wageType;
  String? infoType;
  String? expenseCategory;
  String? amountPerKilometer;
  String? createdAt;
  String? updatedAt;
  String? nightstay;
  String? actualstatus;

  ExpenseList(
      {this.id,
        this.role,
        this.name,
        this.value,
        this.type,
        this.wageType,
        this.infoType,
        this.expenseCategory,
        this.amountPerKilometer,
        this.createdAt,
        this.updatedAt,
        this.nightstay,
        this.actualstatus});

  ExpenseList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    name = json['name'];
    value = json['value'];
    type = json['type'];
    wageType = json['wage_type'];
    infoType = json['info_type'];
    expenseCategory = json['expense_category'];
    amountPerKilometer = json['amount_per_kilometer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    nightstay = json['nightstay'];
    actualstatus = json['actualstatus'];
  }

}
