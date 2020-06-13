import 'dart:core';

// this class corresponds to the incident table
class Incident {
  // id is auto incremented in the database
  // reported_time is set via the flask backend
  int id;
  String province;
  String district;
  String city;
  double locationLat;
  double locationLong;
  String patientName;
  int patientGender;
  DateTime patientDob;
  DateTime reportedTime;
  String description;
  int reportedUserId;
  int patientStatusId;
  bool isVerified;
  int verifiedBy;
  int orgId;

  Incident(
      {this.id,
      this.province,
      this.district,
      this.city,
      this.locationLat,
      this.locationLong,
      this.patientName,
      this.patientGender,
      this.patientDob,
      this.reportedTime,
      this.description,
      this.reportedUserId,
      this.patientStatusId,
      this.isVerified,
      this.verifiedBy,
      this.orgId});

  Map<String, dynamic> toJson() => {
        'id': id,
        'province': province,
        'district': district,
        'city': city,
        'locationLat': locationLat,
        'locationLong': locationLong,
        'patientName': patientName,
        'patientGender': patientGender,
        'patientDob': patientDob,
        'reportedTime': reportedTime,
        'description': description,
        'reportedUserId': reportedUserId,
        'patientStatusId': patientStatusId,
        'isVerified': isVerified,
        'verifiedBy': verifiedBy,
        'orgId': orgId
      };

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
        id: json['id'] as int,
        province: json['province'] as String,
        district: json['district'] as String,
        city: json['city'] as String,
        locationLat: json['locationLat'] as double,
        locationLong: json['locationLong'] as double,
        patientName: json['patientName'] as String,
        patientGender: json['patientGender'] as int,
        patientDob: json['patientDob'] as DateTime,
        reportedTime: json['reportedTime'] as DateTime,
        description: json['description'] as String,
        reportedUserId: json['reportedUserId'] as int,
        patientStatusId: json['patientStatusId'] as int,
        isVerified: json['isVerified'] as bool,
        verifiedBy: json['verifiedBy'] as int,
        orgId: json['orgId'] as int);
  }
}
