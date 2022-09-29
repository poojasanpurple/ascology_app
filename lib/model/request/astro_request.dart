class AstrologerRequestModel
{
  String agent_id;

  AstrologerRequestModel();
  
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'agent_id': agent_id.trim(),

    };

    return map;
  }


}