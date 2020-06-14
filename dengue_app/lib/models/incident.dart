import 'dart:core';
import 'package:intl/intl.dart';

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

  Map toJson() => {
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
        locationLat: json['location_lat'] as double,
        locationLong: json['location_long'] as double,
        patientName: json['patient_name'] as String,
        patientGender: json['patient_gender'] as int,
        // parsing string values to DateTime format
        patientDob: DateFormat('yyyy-M-dd').parse(json['patient_dob']) as DateTime,
        reportedTime: DateTime.parse(json['reported_time']) as DateTime,
        description: json['description'] as String,
        reportedUserId: json['reported_user_id'] as int,
        patientStatusId: json['patient_status_id'] as int,
        isVerified: json['is_verified'] as bool,
        verifiedBy: json['verified_by'] as int,
        orgId: json['org_id'] as int);
  }
}
