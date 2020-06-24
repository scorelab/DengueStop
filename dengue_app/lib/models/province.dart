import 'dart:core';

// this class corresponds to the province table
class Province {
  // id is auto incremented in the database
  int id;
  String name;

  Province({this.id, this.name});

  Map toJson() => {
    'id': id,
    'name': name,
  };

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
        id: json['id'] as int,
        name: json['name'] as String
    );
  }
}