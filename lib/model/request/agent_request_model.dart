class AgentRequestModel
{
  String agent_id;

  AgentRequestModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'agent_id': agent_id.trim(),
    };

    return map;
  }


}