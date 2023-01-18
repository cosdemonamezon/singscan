import 'package:json_annotation/json_annotation.dart';
import 'package:singscan/models/user.dart';

part 'login.g.dart';

@JsonSerializable()
class Login {
  final User user;
  // ignore: non_constant_identifier_names
  final String access_token;
  Login(this.user, this.access_token);

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

  Map<String, dynamic> toJson() => _$LoginToJson(this);
}
