// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concertShow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConcertShow _$ConcertShowFromJson(Map<String, dynamic> json) => ConcertShow(
      json['id'] as String,
      DateTime.parse(json['showDateTime'] as String),
      json['concert'] == null
          ? null
          : Concert.fromJson(json['concert'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ConcertShowToJson(ConcertShow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'showDateTime': instance.showDateTime.toIso8601String(),
      'concert': instance.concert,
    };
