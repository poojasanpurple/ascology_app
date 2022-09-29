class AgentUserRequestModel
{
  String agent_id;
  String user_id;

  AgentUserRequestModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'agent_id': agent_id.trim(),
      'user_id': user_id.trim(),
    };

    return map;
  }


}