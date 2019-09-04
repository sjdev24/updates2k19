// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['first_name'] as String,
    (json['last_name'] as String) ?? (json['last Name'] as String),
    json['enrolment_no'] as String,
    json['mobile_no'] as String,
    json['email'] as String,
    json['department'] as String,
    int.parse(json['year'].toString()),
    json['user_type'] as int,
    json['gender'] as int,
    json['college'] as String,
    json['uid'] as String,
    (json['participated_in'] as List)
        ?.map((e) => (e as Map<dynamic, dynamic>)?.map(
              (k, e) => MapEntry(k as String, e as String),
            ))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'enrolment_no': instance.enrolment_no,
      'mobile_no': instance.mobile_no,
      'email': instance.email,
      'department': instance.department,
      'year': instance.year,
      'user_type': instance.user_type,
      'gender': instance.gender,
      'college': instance.college,
      'participated_in': instance.participated_in,
    };
