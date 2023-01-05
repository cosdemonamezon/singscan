// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Concert _$ConcertFromJson(Map<String, dynamic> json) => Concert(
      json['id'] as String,
      json['concertName'] as String?,
      json['description'] as String?,
      json['cover'] as String?,
      json['salesModel'] as String?,
      (json['concertShows'] as List<dynamic>?)
          ?.map((e) => ConcertShow.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['publicSale'] == null
          ? null
          : DateTime.parse(json['publicSale'] as String),
      json['stateImg'] as String?,
      (json['price'] as num?)?.toDouble(),
      json['closeSale'] == null
          ? null
          : DateTime.parse(json['closeSale'] as String),
    );

Map<String, dynamic> _$ConcertToJson(Concert instance) => <String, dynamic>{
      'id': instance.id,
      'concertName': instance.concertName,
      'description': instance.description,
      'cover': instance.cover,
      'salesModel': instance.salesModel,
      'stateImg': instance.stateImg,
      'publicSale': instance.publicSale?.toIso8601String(),
      'price': instance.price,
      'concertShows': instance.concertShows,
      'closeSale': instance.closeSale?.toIso8601String(),
    };
