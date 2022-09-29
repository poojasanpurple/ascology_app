class AgentLoginRequestModel
{
  String phone;
  String password;
  String token;
  String device_name;
  String device_model;
  String apk_version;
  String imei_number;

  AgentLoginRequestModel();

/*  LoginRequestModel(this.email, this.password, this.token, this.device_name,
      this.device_model, this.apk_version, this.imei_number);*/


  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'phone': phone.trim(),
      'password': password.trim(),
      'token': token.trim(),
      'device_name': device_name.trim(),
      'device_model': device_model.trim(),
      'apk_version': apk_version.trim(),
      'imei_number': imei_number.trim(),
    };

    return map;
  }

}