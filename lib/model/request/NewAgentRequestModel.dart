class NewAgentRequestModel
{
  String agent_id;
  String search;

  NewAgentRequestModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'agent_id': agent_id.trim(),
      'search': search.trim(),
    };

    return map;
  }


}