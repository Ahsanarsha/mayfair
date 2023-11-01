import 'dart:convert';

GetNotificationModel getNotificationModelFromJson(String source) =>
    GetNotificationModel.fromJson(json.decode(source));

class GetNotificationModel {
  bool? status;
  Data? data;

  GetNotificationModel({this.status, this.data});

  GetNotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<Notifications>? notifications;

  Data({this.notifications});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(Notifications.fromJson(v));
      });
    }
  }
}

class Notifications {
  int? id;
  String? userId;
  String? type;
  String? title;
  String? body;
  Null? readAt;
  String? createdAt;
  String? updatedAt;
  User? user;

  Notifications(
      {this.id,
      this.userId,
      this.type,
      this.title,
      this.body,
      this.readAt,
      this.createdAt,
      this.updatedAt,
      this.user});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    title = json['title'];
    body = json['body'];
    readAt = json['read_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
}

class User {
  int? id;
  String? firstname;
  String? lastname;
  String? designation;
  String? role;
  String? userType;
  String? lineManager;
  String? overLimitApprover;
  String? phoneNumber;
  String? sapId;
  String? joiningDate;
  String? baseTown;
  String? zone;
  String? address;
  String? email;
  Null? emailVerifiedAt;
  String? fcmToken;
  Null? currentTeamId;
  String? profilePhotoPath;
  String? createdAt;
  String? updatedAt;
  String? profilePhotoUrl;

  User(
      {this.id,
      this.firstname,
      this.lastname,
      this.designation,
      this.role,
      this.userType,
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
      this.fcmToken,
      this.currentTeamId,
      this.profilePhotoPath,
      this.createdAt,
      this.updatedAt,
      this.profilePhotoUrl});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    designation = json['designation'];
    role = json['role'];
    userType = json['user_type'];
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
    fcmToken = json['fcm_token'];
    currentTeamId = json['current_team_id'];
    profilePhotoPath = json['profile_photo_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profilePhotoUrl = json['profile_photo_url'];
  }
}
