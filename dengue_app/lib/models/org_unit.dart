import 'dart:core';

// this class corresponds to the org unit table
class OrgUnit {
  // id is auto incremented in the database
  int id;
  String province;
  String district;
  String name;
  String contact;

  OrgUnit({this.id, this.province, this.district, this.name, this.contact});

  Map toJson() => {
    'id': id,
    'province': province,
    'district': district,
    'name': name,
    'contact': contact,
  };

  factory OrgUnit.fromJson(Map<String, dynamic> json) {
    return OrgUnit(
        id: json['id'] as int,
        province: json['province'] as String,
        district: json['district'] as String,
        name: json['name'] as String,
        contact: json['contact'] as String
    );
  }
}