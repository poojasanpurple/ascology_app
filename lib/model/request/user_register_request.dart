class UserRegisterRequestModel
{
  String email;
  String name;
  String mobile;
  String gender;
  String password;
  String device_name;
  String device_model;
  String apk_version;
  String imei_number;
  String date_birth;
  String place_birth;
  String time;

  UserRegisterRequestModel();

/*  LoginRequestModel(this.email, this.password, this.token, this.device_name,
      this.device_model, this.apk_version, this.imei_number);*/

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email.trim(),
      'name': name.trim(),
      'mobile': mobile.trim(),
      'gender': gender.trim(),
      'password': password.trim(),
      'device_name': device_name.trim(),
      'device_model': device_model.trim(),
      'apk_version': apk_version.trim(),
      'imei_number': imei_number.trim(),
      'date_birth': date_birth.trim(),
      'place_birth': place_birth.trim(),
      'time': time.trim(),
    };

    return map;
  }
}