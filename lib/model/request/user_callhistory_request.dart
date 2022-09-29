class UserCallHistoryRequestModel
{
  String mobile;
  String search;
  String fromdate;
  String todate;

  UserCallHistoryRequestModel();


  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'mobile': mobile == null ? null : mobile,
      'search': search == null ? null : search,
      'fromdate': fromdate == null ? null : fromdate,
      'todate': todate == null ? null : todate,

    };

    return map;
  }


}