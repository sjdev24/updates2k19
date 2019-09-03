// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    json['eid'] as String,
    json['event_name'] as String,
    (json['event_schedule'] as List)
        ?.map((e) => e as Map<dynamic, dynamic>)
        ?.toList(),
    json['description'] as String,
    json['team_size'] as int,
    json['is_paid'] as bool,
    (json['amount'] as num)?.toDouble(),
    (json['faculty_head'] as List)?.map((e) => e as String)?.toList(),
    (json['student_coord'] as List)?.map((e) => e as String)?.toList(),
    (json['student_vol'] as List)?.map((e) => e as String)?.toList(),
    json['rounds'] as int,
    json['poster'] as String,
    json['flyer'] as String,
    json['need_abstract'] as bool,
    json['end_registration'] == null ? null : json['end_registration'].toDate(),
    json['ln_hindi'] as String,
  );
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'event_name': instance.event_name,
      'event_schedule': instance.event_schedule,
      'description': instance.description,
      'end_registration': instance.end_registration?.toIso8601String(),
      'team_size': instance.team_size,
      'is_paid': instance.is_paid,
      'amount': instance.amount,
      'need_abstract': instance.need_abstract,
      'faculty_head': instance.faculty_head,
      'student_coord': instance.student_coord,
      'student_vol': instance.student_vol,
      'rounds': instance.rounds,
      'poster': instance.poster,
      'flyer': instance.flyer,
      'ln_hindi': instance.ln_hindi,
    };
