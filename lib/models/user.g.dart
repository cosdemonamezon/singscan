// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as String,
      json['firstname'] as String?,
      json['lastname'] as String?,
      json['password'] as String?,
      json['email'] as String?,
      json['phoneNumber'] as String?,
      json['profileImage'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'password': instance.password,
      'profileImage': instance.profileImage,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
    };
