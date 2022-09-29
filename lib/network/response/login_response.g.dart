// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return LoginResponse(
    status: json['status'] as bool,
    message: json['message'] as String,
    user_id: json['user_id'] as String,
    email: json['email'] as String,
    mobile: json['mobile'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'user_id': instance.user_id,
      'email': instance.email,
      'mobile': instance.mobile,
      'name': instance.name,
    };
