import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

class UserType {
  static const int STUDENT = 0;
  static const int VOLUNTEER = 1;
  static const int COORDINATOR = 2;
  static const int HEAD = 3;
}

@JsonSerializable()
class User {
  final String first_name;
  final String last_name;
  final String enrolment_no;
  final String mobile_no;
  final String email;
  final String department;
  final int year;
  final int user_type;
  final int gender;
  final String college;
  final String uid;
  final List<Map<String, String>> participated_in;

  User(
      this.first_name,
      this.last_name,
      this.enrolment_no,
      this.mobile_no,
      this.email,
      this.department,
      this.year,
      this.user_type,
      this.gender,
      this.college,
      this.uid,
      this.participated_in);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
