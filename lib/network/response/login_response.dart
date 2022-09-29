import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse
{

  @JsonKey(name : 'status')
  final bool  status;

  @JsonKey(name : 'message')
  final String message;

  @JsonKey(name : 'user_id')
  final String user_id;

  @JsonKey(name : 'email')
  final String email;

  @JsonKey(name : 'mobile')
  final String mobile;

  @JsonKey(name : 'name')
  final String name;

  LoginResponse({  this.status,
     this.message,
     this.user_id,
     this.email,
     this.mobile,
     this.name});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

}
