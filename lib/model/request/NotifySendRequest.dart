class NotifySendRequestModel
{
  String agent_id;
  String user_id;
  String token;


  NotifySendRequestModel();

/*  LoginRequestModel(this.email, this.password, this.token, this.device_name,
      this.device_model, this.apk_version, this.imei_number);*/

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'agent_id': agent_id.trim(),
      'user_id': user_id.trim(),
      'token': token.trim(),

    };

    return map;
  }
}