class StatusRequestModel
{
  String agent_id;
  String type;
  String date;

  StatusRequestModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'agent_id': agent_id.trim(),
      'type': type.trim(),
      'date': date.trim(),
    };

    return map;
  }


}