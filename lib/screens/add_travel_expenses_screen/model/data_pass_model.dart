
import 'package:get/get.dart';
import 'package:mayfair/data/model/GetTravelExpenseByIdModel.dart';

class DataPassModel{

  String? id;
  DateTime currentDate;
  RxBool isUpdate;

  String travelTo;
  String station;
  String kilometer;
  String fuelAmount;
  String amountPkm;
  String sameDayReturn;
  String note;
  String grandTotal;
  String nightStay;
  List<TravelExpenseData>? travelExpenseData;

  DataPassModel(
      this.id,
      this.currentDate,
      this.isUpdate,
      this.travelTo,
      this.station,
      this.kilometer,
      this.fuelAmount,
      this.amountPkm,
      this.sameDayReturn,
      this.note,
      this.grandTotal,
      this.nightStay,
     this.travelExpenseData);

}
// class TravelExpenseData {
//   int? id;
//   String? parentId;
//   String? userId;
//   String? name;
//   String? value;
//   Null? note;
//   String? managerNote;
//   String? status;
//   String? managerLevel;
//   String? createdAt;
//   String? updatedAt;
//
//   TravelExpenseData(
//       {this.id,
//         this.parentId,
//         this.userId,
//         this.name,
//         this.value,
//         this.note,
//         this.managerNote,
//         this.status,
//         this.managerLevel,
//         this.createdAt,
//         this.updatedAt});
//
//   TravelExpenseData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     parentId = json['parent_id'];
//     userId = json['user_id'];
//     name = json['name'];
//     value = json['value'];
//     note = json['note'];
//     managerNote = json['manager_note'];
//     status = json['status'];
//     managerLevel = json['manager_level'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['parent_id'] = this.parentId;
//     data['user_id'] = this.userId;
//     data['name'] = this.name;
//     data['value'] = this.value;
//     data['note'] = this.note;
//     data['manager_note'] = this.managerNote;
//     data['status'] = this.status;
//     data['manager_level'] = this.managerLevel;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }