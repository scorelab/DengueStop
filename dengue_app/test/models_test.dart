import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:dengue_app/models/district.dart';
import 'package:dengue_app/models/incident.dart';
import 'package:dengue_app/models/org_unit.dart';
import 'package:dengue_app/models/province.dart';
import 'package:dengue_app/models/status.dart';
import 'package:dengue_app/models/user.dart';

void main() {
  dynamic dateTimeEncode(dynamic item) {
    // this converts DateTime objects to JSON
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  group('Testing model classes', () {
    test('testing JSON to object conversion of District Class', () {
      var jsonObj = jsonEncode({
        'id': 12,
        'province_id': 2,
        'name': "Colombo",
      });
      District obj = District.fromJson(json.decode(jsonObj));
      expect(obj.id, 12);
      expect(obj.provinceId, 2);
      expect(obj.name, "Colombo");
    });

    test('testing JSON to object conversion of Incident Class', () {
      var jsonObj = jsonEncode({
        'id': 1,
        'province': 'Western',
        'district': 'Colombo',
        'city': 'Kelaniya',
        'location_lat': 10.0000,
        'location_long': 20.0000,
        'patient_name': "Barry Allen",
        'patient_gender': "m",
        'patient_dob': "2020-06-02 00:00:00",
        'reported_time': "2020-06-25 01:53:38",
        'description': "test",
        'reported_user_id': 1,
        'patient_status_id': 1,
        'is_verified': 0,
        'verified_by': null,
        'org_id': 1
      }, toEncodable: dateTimeEncode);
      Incident obj = Incident.fromJson(json.decode(jsonObj));
      expect(obj.id, 1);
      expect(obj.province, "Western");
      expect(obj.district, "Colombo");
      expect(obj.city, "Kelaniya");
      expect(obj.locationLat, 10.0000);
      expect(obj.locationLong, 20.0000);
      expect(obj.patientName, "Barry Allen");
      expect(obj.patientGender, "m");
      expect(obj.patientDob, DateTime(2020, 06, 02));
      expect(obj.reportedTime, DateTime(2020, 06, 25, 01, 53, 38));
      expect(obj.description, "test");
      expect(obj.reportedUserId, 1);
      expect(obj.patientStatusId, 1);
      expect(obj.isVerified, 0);
      expect(obj.verifiedBy, null);
      expect(obj.orgId, 1);
    });

    test('testing JSON to object conversion of Org Unit Class', () {
      var jsonObj = jsonEncode({
        'id': 1,
        'province': "Western",
        'district': "Colombo",
        'name': "NHSL",
        'contact': "0112727727",
      });
      OrgUnit obj = OrgUnit.fromJson(json.decode(jsonObj));
      expect(obj.id, 1);
      expect(obj.province, "Western");
      expect(obj.district, "Colombo");
      expect(obj.name, "NHSL");
      expect(obj.contact, "0112727727");
    });

    test('testing JSON to object conversion of Province Class', () {
      var jsonObj = jsonEncode({
        'id': 2,
        'name': "Western",
      });
      Province obj = Province.fromJson(json.decode(jsonObj));
      expect(obj.id, 2);
      expect(obj.name, "Western");
    });

    test('testing JSON to object conversion of Status Class', () {
      var jsonObj = jsonEncode({
        'id': 2,
        'status': "Status Name",
      });
      Status obj = Status.fromJson(json.decode(jsonObj));
      expect(obj.id, 2);
      expect(obj.status, "Status Name");
    });

    test('testing JSON to object conversion of User Class', () {
      var jsonObj = jsonEncode({
        'id': 1,
        'telephone': "0112729729",
        'first_name': "Barry",
        'last_name': "Allen",
        'nic_number': "000111222333",
        'email': "barry@allen.com",
        'password': "test1234",
        'salt': "salt1234"
      });
      User obj = User.fromJson(json.decode(jsonObj));
      expect(obj.id, 1);
      expect(obj.telephone, "0112729729");
      expect(obj.firstName, "Barry");
      expect(obj.lastName, "Allen");
      expect(obj.nicNumber, "000111222333");
      expect(obj.email, "barry@allen.com");
      expect(obj.password, "test1234");
      expect(obj.salt, "salt1234");
    });
  });
}
