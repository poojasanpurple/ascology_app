class AgentCallHistoryRequestModel
{
  String extension;
  String search;
  String fromdate;
  String todate;

  AgentCallHistoryRequestModel();


  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'extension': extension.trim(),
      'search': search.trim(),
      'fromdate': fromdate.trim(),
      'todate': todate.trim(),

    };

    return map;
  }


}