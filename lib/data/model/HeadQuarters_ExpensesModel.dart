import 'Data.dart';

/// Status : true
/// data : [{"id":3,"role":"ASM","name":"Maintance","value":"18","type":"daily","wage_type":"49","info_type":"Dolorum velit anim i","expense_category":1,"amount_per_kilometer":"500","created_at":"2022-05-26T08:49:09.000000Z","updated_at":"2022-05-26T08:49:09.000000Z"},{"id":4,"role":"ASM","name":"internet","value":"22","type":"monthly","wage_type":"38","info_type":"Eius tenetur eum ven","expense_category":1,"amount_per_kilometer":"400","created_at":"2022-05-26T08:49:31.000000Z","updated_at":"2022-05-26T08:49:31.000000Z"},{"id":5,"role":"ASM","name":"Fuel","value":"90","type":"daily","wage_type":"32","info_type":"Odio aliquip vitae n","expense_category":1,"amount_per_kilometer":"100","created_at":"2022-05-27T05:04:26.000000Z","updated_at":"2022-05-27T05:04:51.000000Z"}]

class HeadQuartersExpensesModel {
  HeadQuartersExpensesModel({
      bool? status, 
      List<Data>? data,}){
    _status = status;
    _data = data;
}

  HeadQuartersExpensesModel.fromJson(dynamic json) {
    _status = json['Status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _status;
  List<Data>? _data;
HeadQuartersExpensesModel copyWith({  bool? status,
  List<Data>? data,
}) => HeadQuartersExpensesModel(  status: status ?? _status,
  data: data ?? _data,
);
  bool? get status => _status;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = _status;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}