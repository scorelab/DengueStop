import 'dart:core';

// this class corresponds to the district table
class District {
  // id is auto incremented in the database
  int id;
  int provinceId;
  String name;

  District({this.id, this.provinceId, this.name});

  Map toJson() => {
    'id': id,
    'provinceId': provinceId,
    'name': name,
  };

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
        id: json['id'] as int,
        provinceId: json['province_id'] as int,
        name: json['name'] as String
    );
  }
}