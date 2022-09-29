class MatchMakingRequestModel
{
  String m_day;
  String m_month;
  String m_year;
  String m_hour;
  String m_minute;
  String m_lat;
  String m_lon;

  String f_day;
  String f_month;
  String f_year;
  String f_hour;
  String f_minute;
  String f_lat;
  String f_lon;


  MatchMakingRequestModel();


  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'm_day': m_day.trim(),
      'm_month': m_month.trim(),
      'm_year': m_year.trim(),
      'm_hour': m_hour.trim(),
      'm_minute': m_minute.trim(),
      'm_lat': m_lat.trim(),
      'm_lon':m_lon.trim(),

      'f_day': f_day.trim(),
      'f_month': f_month.trim(),
      'f_year': f_year.trim(),
      'f_hour': f_hour.trim(),
      'f_minute': f_minute.trim(),
      'f_lat': f_lat.trim(),
      'f_lon':f_lon.trim(),

    };

    return map;
  }


}