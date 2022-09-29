class AgentDelRequestModel
{
  String extension;

  AgentDelRequestModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'extension': extension.trim(),

    };

    return map;
  }


}