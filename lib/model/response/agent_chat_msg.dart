class AgentChatMsg
{
  String name;
  String user_id;
  String agent_id;
  String txt_message;


  AgentChatMsg();

  factory AgentChatMsg.fromJson(Map<String, dynamic> json) {
    AgentChatMsg chatDetail = new AgentChatMsg();
    chatDetail.name =  json["name"];
    chatDetail.user_id =  json["user_id"];
    chatDetail.agent_id =  json["agent_id"];
    chatDetail.txt_message =  json["txt_message"];

    return chatDetail;

  }
}