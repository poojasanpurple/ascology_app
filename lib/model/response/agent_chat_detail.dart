class AgentChatDetail
{
  String name;
  String user_id;
  String agent_id;
  String image;


  AgentChatDetail();

  factory AgentChatDetail.fromJson(Map<String, dynamic> json) {
    AgentChatDetail chatDetail = new AgentChatDetail();
    chatDetail.name =  json["name"];
    chatDetail.user_id =  json["user_id"];
    chatDetail.agent_id =  json["agent_id"];
    chatDetail.image =  json["image"];

    return chatDetail;

  }
}