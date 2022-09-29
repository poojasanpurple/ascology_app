class UserChatDetail
{
  String agentname;
  String user_id;
  String agent_id;
  String image;


  UserChatDetail();

  factory UserChatDetail.fromJson(Map<String, dynamic> json) {
    UserChatDetail chatDetail = new UserChatDetail();
    chatDetail.agent_id =  json["agent_id"];
    chatDetail.agentname =  json["agentname"];
    chatDetail.user_id =  json["user_id"];
    chatDetail.image =  json["image"];

    return chatDetail;

  }
}