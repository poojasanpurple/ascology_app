class AgentChatHistRequest
{
  String extension;

  AgentChatHistRequest();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'extension': extension.trim(),

    };

    return map;
  }


}