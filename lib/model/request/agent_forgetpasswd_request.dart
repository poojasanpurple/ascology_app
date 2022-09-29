class AgentForgetPasswdRequestModel
{
  String mobile;

  AgentForgetPasswdRequestModel();

/*  LoginRequestModel(this.email, this.password, this.token, this.device_name,
      this.device_model, this.apk_version, this.imei_number);*/

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'mobile': mobile.trim(),

    };

    return map;
  }
}