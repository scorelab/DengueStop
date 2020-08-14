import 'dart:core';
import 'package:intl/intl.dart';

// this class corresponds to the event table
class Event {
  // id is auto incremented in the database
  // reported_time is set via the flask backend
  int id;
  String name;
  String venue;
  double locationLat;
  double locationLong;
  DateTime startTime;
  DateTime dateCreated;
  double duration;
  String coordinatorName;
  String coordinatorContact;
  int statusId;
  int orgId;
  int createdBy;
  String description;

  Event(
      {this.id,
      this.name,
      this.venue,
      this.locationLat,
      this.locationLong,
      this.startTime,
      this.dateCreated,
      this.duration,
      this.coordinatorName,
      this.coordinatorContact,
      this.statusId,
      this.createdBy,
      this.description,
      this.orgId});

  Map toJson() => {
        'id': id,
        'name': name,
        'venue': venue,
        'locationLat': locationLat,
        'locationLong': locationLong,
        'startTime': startTime,
        'dateCreated': dateCreated,
        'duration': duration,
        'coordinatorName': coordinatorName,
        'coordinatorContact': coordinatorContact,
        'statusId': statusId,
        'createdBy': createdBy,
        'description': description,
        'orgId': orgId
      };

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['id'] as int,
        name: json['name'] as String,
        venue: json['venue'] as String,
        locationLat: json['location_lat'] as double,
        locationLong: json['location_long'] as double,
        // parsing string values to DateTime format
        startTime: DateTime.parse(json['start_time']) as DateTime,
        dateCreated: DateTime.parse(json['date_created']) as DateTime,
        duration: json['duration'] as double,
        coordinatorName: json['coordinator_name'] as String,
        coordinatorContact: json['coordinator_contact'] as String,
        description: json['description'] as String,
        statusId: json['status_id'] as int,
        createdBy: json['created_by'] as int,
        orgId: json['org_id'] as int);
  }
}
