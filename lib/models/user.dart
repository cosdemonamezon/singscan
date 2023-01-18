import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User(
    this.id,
    this.firstName,
    this.lastName,
    this.role,
    this.username,
  );

  final String id;
  String? firstName;
  String? lastName;
  String? role;
  String? username;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
