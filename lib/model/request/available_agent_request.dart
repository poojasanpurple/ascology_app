class AvailableAgentRequestModel
{
  String service,user_id;

  AvailableAgentRequestModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'service': service.trim(),
      'user_id': user_id.trim(),

    };

    return map;
  }


}