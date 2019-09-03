import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  final String eid;
  final String event_name;
  final List<Map<dynamic, dynamic>> event_schedule;
  final String description;
  final DateTime end_registration;
  final int team_size;
  bool is_paid = false;
  final double amount;
  final bool need_abstract;
  List<String> faculty_head = <String>[];
  List<String> student_coord = <String>[];
  List<String> student_vol = <String>[];
  final int rounds;
  final String poster;
  final String flyer;
  final String ln_hindi;

  Event(
      this.eid,
      this.event_name,
      this.event_schedule,
      this.description,
      this.team_size,
      this.is_paid,
      this.amount,
      this.faculty_head,
      this.student_coord,
      this.student_vol,
      this.rounds,
      this.poster,
      this.flyer,
      this.need_abstract,
      this.end_registration,
      this.ln_hindi);

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);

  String get imageID => event_name.toLowerCase().replaceAll(' ', '_');
}
