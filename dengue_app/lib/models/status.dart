import 'dart:core';

// this class corresponds to the patient status and event status table
class Status {
  // id is auto incremented in the database
  int id;
  String status;

  Status({this.id, this.status});

  Map toJson() => {
    'id': id,
    'status': status,
  };

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
        id: json['id'] as int,
        status: json['status'] as String
    );
  }
}