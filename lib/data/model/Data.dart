/// id : 3
/// role : "ASM"
/// name : "Maintance"
/// value : "18"
/// type : "daily"
/// wage_type : "49"
/// info_type : "Dolorum velit anim i"
/// expense_category : 1
/// amount_per_kilometer : "500"
/// created_at : "2022-05-26T08:49:09.000000Z"
/// updated_at : "2022-05-26T08:49:09.000000Z"

class Data {
  Data({
      int? id, 
      String? role, 
      String? name, 
      String? value, 
      String? type, 
      String? wageType, 
      String? infoType, 
      int? expenseCategory, 
      String? amountPerKilometer, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _role = role;
    _name = name;
    _value = value;
    _type = type;
    _wageType = wageType;
    _infoType = infoType;
    _expenseCategory = expenseCategory;
    _amountPerKilometer = amountPerKilometer;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _role = json['role'];
    _name = json['name'];
    _value = json['value'];
    _type = json['type'];
    _wageType = json['wage_type'];
    _infoType = json['info_type'];
    _expenseCategory = json['expense_category'];
    _amountPerKilometer = json['amount_per_kilometer'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  int? _id;
  String? _role;
  String? _name;
  String? _value;
  String? _type;
  String? _wageType;
  String? _infoType;
  int? _expenseCategory;
  String? _amountPerKilometer;
  String? _createdAt;
  String? _updatedAt;
Data copyWith({  int? id,
  String? role,
  String? name,
  String? value,
  String? type,
  String? wageType,
  String? infoType,
  int? expenseCategory,
  String? amountPerKilometer,
  String? createdAt,
  String? updatedAt,
}) => Data(  id: id ?? _id,
  role: role ?? _role,
  name: name ?? _name,
  value: value ?? _value,
  type: type ?? _type,
  wageType: wageType ?? _wageType,
  infoType: infoType ?? _infoType,
  expenseCategory: expenseCategory ?? _expenseCategory,
  amountPerKilometer: amountPerKilometer ?? _amountPerKilometer,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  int? get id => _id;
  String? get role => _role;
  String? get name => _name;
  String? get value => _value;
  String? get type => _type;
  String? get wageType => _wageType;
  String? get infoType => _infoType;
  int? get expenseCategory => _expenseCategory;
  String? get amountPerKilometer => _amountPerKilometer;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['role'] = _role;
    map['name'] = _name;
    map['value'] = _value;
    map['type'] = _type;
    map['wage_type'] = _wageType;
    map['info_type'] = _infoType;
    map['expense_category'] = _expenseCategory;
    map['amount_per_kilometer'] = _amountPerKilometer;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}