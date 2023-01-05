import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User(
    this.id,
    this.firstname,
    this.lastname,
    this.password,
    this.email,
    this.phoneNumber,
    this.profileImage,
  );

  final String id;
  String? firstname;
  String? lastname;
  String? password;
  String? profileImage;
  String? email;
  String? phoneNumber;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
