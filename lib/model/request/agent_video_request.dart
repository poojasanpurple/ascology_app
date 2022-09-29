class AgentVideoRequestModel
{
  String agent_id;
  String video;

  AgentVideoRequestModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'agent_id': agent_id.trim(),
      'video': video.trim(),
    };

    return map;
  }


}