import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  final String username;
  final String password;
  final int? expiresInMins;

  LoginRequest({
    required this.username,
    required this.password,
    this.expiresInMins
  });

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}