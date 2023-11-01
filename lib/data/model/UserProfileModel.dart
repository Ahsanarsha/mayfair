import 'dart:convert';
/// success : true
/// data : {"id":1,"firstname":"wazir","lastname":"khan","designation":"sub admin","role":"sub admin","line_manager":"sst","over_limit_approver":"sst","phone_number":"03445853814","sap_id":"22","joining_date":"25","base_town":"25","zone":"lahore","address":"lahore","email":"wazir@gmail.com","email_verified_at":null,"two_factor_confirmed_at":null,"current_team_id":null,"profile_photo_path":null,"created_at":"2022-05-20T06:56:07.000000Z","updated_at":"2022-05-20T06:56:07.000000Z","profile_photo_url":"https://ui-avatars.com/api/?name=&color=7F9CF5&background=EBF4FF"}
/// message : "user data"

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));
String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());
class UserProfileModel {
  UserProfileModel({
      this.success, 
      this.data, 
      this.message,});

  UserProfileModel.fromJson(dynamic json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }
  bool? success;
  Data? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['message'] = message;
    return map;
  }

}

/// id : 1
/// firstname : "wazir"
/// lastname : "khan"
/// designation : "sub admin"
/// role : "sub admin"
/// line_manager : "sst"
/// over_limit_approver : "sst"
/// phone_number : "03445853814"
/// sap_id : "22"
/// joining_date : "25"
/// base_town : "25"
/// zone : "lahore"
/// address : "lahore"
/// email : "wazir@gmail.com"
/// email_verified_at : null
/// two_factor_confirmed_at : null
/// current_team_id : null
/// profile_photo_path : null
/// created_at : "2022-05-20T06:56:07.000000Z"
/// updated_at : "2022-05-20T06:56:07.000000Z"
/// profile_photo_url : "https://ui-avatars.com/api/?name=&color=7F9CF5&background=EBF4FF"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.id, 
      this.firstname, 
      this.lastname, 
      this.designation, 
      this.role, 
      this.lineManager, 
      this.overLimitApprover, 
      this.phoneNumber, 
      this.sapId, 
      this.joiningDate, 
      this.baseTown, 
      this.zone, 
      this.address, 
      this.email, 
      this.emailVerifiedAt, 
      this.twoFactorConfirmedAt, 
      this.currentTeamId, 
      this.profilePhotoPath, 
      this.createdAt, 
      this.updatedAt, 
      this.profilePhotoUrl,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    designation = json['designation'];
    role = json['role'];
    lineManager = json['line_manager'];
    overLimitApprover = json['over_limit_approver'];
    phoneNumber = json['phone_number'];
    sapId = json['sap_id'];
    joiningDate = json['joining_date'];
    baseTown = json['base_town'];
    zone = json['zone'];
    address = json['address'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    twoFactorConfirmedAt = json['two_factor_confirmed_at'];
    currentTeamId = json['current_team_id'];
    profilePhotoPath = json['profile_photo_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profilePhotoUrl = json['profile_photo_url'];
  }
  int? id;
  String? firstname;
  String? lastname;
  String? designation;
  String? role;
  String? lineManager;
  String? overLimitApprover;
  String? phoneNumber;
  String? sapId;
  String? joiningDate;
  String? baseTown;
  String? zone;
  String? address;
  String? email;
  dynamic emailVerifiedAt;
  dynamic twoFactorConfirmedAt;
  dynamic currentTeamId;
  dynamic profilePhotoPath;
  String? createdAt;
  String? updatedAt;
  String? profilePhotoUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    map['designation'] = designation;
    map['role'] = role;
    map['line_manager'] = lineManager;
    map['over_limit_approver'] = overLimitApprover;
    map['phone_number'] = phoneNumber;
    map['sap_id'] = sapId;
    map['joining_date'] = joiningDate;
    map['base_town'] = baseTown;
    map['zone'] = zone;
    map['address'] = address;
    map['email'] = email;
    map['email_verified_at'] = emailVerifiedAt;
    map['two_factor_confirmed_at'] = twoFactorConfirmedAt;
    map['current_team_id'] = currentTeamId;
    map['profile_photo_path'] = profilePhotoPath;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['profile_photo_url'] = profilePhotoUrl;
    return map;
  }

}