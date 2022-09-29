import 'package:ascology_app/model/response/astrologer_listing_response.dart';

class UserDetails
{

  String id;
  String name;
  String mobile;
  String rtn;
  String email;
  String address;
  String gender;
  String state;
  String wallet;
  String user_expiry_date;
  String voucher_expiry_date;
  String added_date;
  String voucher_code;
  String image;
  String forgot_pwd_tocken;
  String is_valid_reset_password_link;
  String token;
  String otp;
  String password;
  String updated_at;
  String is_active;
  String service_type;
  String e_rate;
  String e_discount;
  String interest;
  String made_by;
  String device_name;
  String device_model;
  String apk_version;
  String imei_number;
  String short_description;
  String date_birth;
  String place_birth;
  String time;

  UserDetails();

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    UserDetails userDetails = new UserDetails();
    userDetails.id =  json["id"];
    userDetails.name =  json["name"];
    userDetails.mobile =  json["mobile"];
    userDetails.rtn =  json["rtn"];
    userDetails.email =  json["email"];
    userDetails.address =  json["address"];
    userDetails.gender =  json["gender"];
    userDetails.state =  json["state"];
    userDetails.wallet =  json["wallet"];
    userDetails.user_expiry_date =  json["user_expiry_date"];
    userDetails.voucher_expiry_date =  json["voucher_expiry_date"];
    userDetails.added_date =  json["added_date"];
    userDetails.voucher_code =  json["voucher_code"];
    userDetails.image =  json["image"];
    userDetails.password =  json["password"];
    userDetails.updated_at =  json["updated_at"];
    userDetails.is_active =  json["is_active"];
    userDetails.e_rate =  json["e_rate"];
    userDetails.service_type =  json["service_type"];
    userDetails.interest =  json["interest"];
    userDetails.made_by =  json["made_by"];
    userDetails.device_name =  json["device_name"];
    userDetails.otp =  json["otp"];
    userDetails.device_name =  json["device_name"];
    userDetails.device_model =  json["device_model"];
    userDetails.apk_version =  json["apk_version"];
    userDetails.imei_number =  json["imei_number"];
    userDetails.short_description =  json["short_description"];
    userDetails.date_birth =  json["date_birth"];
    userDetails.place_birth =  json["place_birth"];
    userDetails.time =  json["time"];
    return userDetails;

  }
}