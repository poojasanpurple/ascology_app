class AgentUpdateProfileRequest
{
  String agent_id;
  String name;
  String service;
  String language;
  String timing;
  String experience;
  String description;

  AgentUpdateProfileRequest();



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'agent_id': agent_id.trim(),
      'name': name.trim(),
      'service': service.trim(),
      'language': language.trim(),
      'timing': timing.trim(),
      'experience': experience.trim(),
      'description': description.trim(),
    };

    return map;
  }


}