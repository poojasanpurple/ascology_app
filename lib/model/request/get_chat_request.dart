class GetChatListRequestModel
{
  String agent_id;
  String user_id;
  String chat_from;
  String chat_to;


  GetChatListRequestModel();

/*  LoginRequestModel(this.email, this.password, this.token, this.device_name,
      this.device_model, this.apk_version, this.imei_number);*/

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'agent_id': agent_id.trim(),
      'user_id': user_id.trim(),
      'chat_from': chat_from.trim(),
      'chat_to': chat_to.trim(),
    };
    return map;
  }
}