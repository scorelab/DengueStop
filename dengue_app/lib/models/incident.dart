import 'dart:core';

// this class corresponds to the incident table
class Incident {
  // id is auto incremented in the database
  // reported_time is set via the flask backend
  String province;
  String district;
  String city;
  double locationLat;
  double locationLong;
  String patientName;
  int patientGender;
  DateTime patientDob;
  String description;
  int reportedUserId;
  int patientStatusId;
  bool isVerified;
  int verifiedBy;
  int orgId;

  Incident({this.province, this.district, this.city, this.locationLat, this.locationLong, this.patientName, this.patientGender, this.patientDob,
    this.description, this.reportedUserId, this.patientStatusId, this.isVerified, this.verifiedBy, this.orgId});
}
