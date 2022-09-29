class UpdateChatStatusRequestModel
{
  String agent_id;
  String ChatStatus;
  String user_id;


  UpdateChatStatusRequestModel();

/*  LoginRequestModel(this.email, this.password, this.token, this.device_name,
      this.device_model, this.apk_version, this.imei_number);*/

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'agent_id': agent_id.trim(),
      'ChatStatus': ChatStatus.trim(),
      'user_id': user_id.trim(),

    };

    return map;
  }
}