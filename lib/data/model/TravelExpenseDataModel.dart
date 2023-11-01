import 'dart:convert';

TravelExpenseDataModel travelExpenseDataModelFromJson(String srt) =>
    TravelExpenseDataModel.fromJson(json.decode(srt));

class TravelExpenseDataModel {
  bool? status;
  Data? data;

  TravelExpenseDataModel({this.status, this.data});

  TravelExpenseDataModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  String? isEdit;
  List<Distance>? cityTo;
  List<FuelRates>? fuelRates;
  var travelDailyAllowance;
  List<TravelExpense>? travelExpense;
  List<FuelPKM>? fuelPKM;

  Data(
      { this.isEdit,
        this.cityTo,
      this.fuelRates,
      this.travelDailyAllowance,
      this.travelExpense,
      this.fuelPKM});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['city_to'] != null) {
      cityTo = <Distance>[];
      json['city_to'].forEach((v) {
        cityTo!.add(Distance.fromJson(v));
      });
    }
    if (json['fuel_rates'] != null) {
      fuelRates = <FuelRates>[];
      json['fuel_rates'].forEach((v) {
        fuelRates!.add(FuelRates.fromJson(v));
      });
    }
    if (json['fuelPKM'] != null) {
      fuelPKM = <FuelPKM>[];
      json['fuelPKM'].forEach((v) {
        fuelPKM!.add(new FuelPKM.fromJson(v));
      });
    }
    isEdit = json['travel_edit'][0]['travel_rate_access'];
    travelDailyAllowance = json['travel_daily_allowance'];

    travelExpense = List<TravelExpense>.from(
        json["travel_expense"].map((x) => TravelExpense.fromJson(x)));
  }
}

class Distance {
  String? cityTo;
  String? kilometer;
  String? createdAt;
  String? updatedAt;

  Distance({this.cityTo, this.kilometer, this.createdAt, this.updatedAt});

  Distance.fromJson(Map<String, dynamic> json) {
    cityTo = json['city_to'];
    kilometer = json['kilometer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class FuelRates {
  int? id;
  String? price;
  String? dateFrom;
  String? dateTo;
  String? createdAt;
  String? updatedAt;

  FuelRates(
      {this.id,
      this.price,
      this.dateFrom,
      this.dateTo,
      this.createdAt,
      this.updatedAt});

  FuelRates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    dateFrom = json['fromdate'];
    dateTo = json['todate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class TravelExpense {
  TravelExpense({
    this.id,
    this.role,
    this.name,
    this.value,
    this.type,
    this.wageType,
    this.infoType,
    this.isEdit,
    this.expenseCategory,
    this.amountPerKilometer,
    this.createdAt,
    this.updatedAt,
    this.nightStay,
  });

  int? id;
  String? role;
  String? name;
  String? isEdit;
  String? value;
  String? type;
  String? wageType;
  String? infoType;
  String? expenseCategory;
  String? amountPerKilometer;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? nightStay;

  factory TravelExpense.fromJson(Map<String, dynamic> json) => TravelExpense(
        id: json["id"],
        role: json["role"],
        name: json["name"],
        value: json["value"],
        type: json["type"],
        isEdit: json["travel_rate_access"],
        wageType: json["wage_type"],
        infoType: json["info_type"],
        nightStay: int.parse(json["nightstay"]),
        expenseCategory: json["expense_category"],
        amountPerKilometer: json["amount_per_kilometer"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
}

class FuelPKM {
  int? id;
  String? price;
  String? staffroleId;
  String? createdAt;
  String? updatedAt;

  FuelPKM({
    this.id,
    this.price,
    this.staffroleId,
    this.createdAt,
    this.updatedAt,
  });

  FuelPKM.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    staffroleId = json['staffrole_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}
