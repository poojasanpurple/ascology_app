class LoginResponseModel
{
  bool status;
  String message;
  String user_id;
  String email;
  String mobile;
  String name;
  String device_name;
  String device_model;
  String apk_version;
  String imei_number;
  String password;
  String token;



  LoginResponseModel({
      this.status,
      this.message,
      this.user_id,
      this.email,
      this.mobile,
      this.name,
      this.device_name,
      this.device_model,
      this.apk_version,
      this.imei_number,
      this.password,
      this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json){
   // LoginResponseModel loginResponseModel = new LoginResponseModel();
    return LoginResponseModel(
        status: json["status"] != null ? json["status"] : "",
      message: json["message"] != null ? json["message"] : "",
      user_id: json["user_id"] != null ? json["user_id"] : "",
      email: json["email"] != null ? json["email"] : "",
      mobile: json["mobile"] != null ? json["mobile"] : "",
      name: json["name"] != null ? json["name"] : "",
      device_name: json["device_name"] != null ? json["device_name"] : "",
      device_model: json["device_model"] != null ? json["device_model"] : "",
      apk_version: json["apk_version"] != null ? json["apk_version"] : "",
      imei_number: json["imei_number"] != null ? json["imei_number"] : "",
      password: json["password"] != null ? json["password"] : "",
      token: json["token"] != null ? json["token"] : "",

    );

  }

}