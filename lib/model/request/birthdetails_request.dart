class BirthDetailsRequestModel
{
  String year;
  String month;
  String day;
  String hour;
  String min;
  String lat;
  String lon;
  String tzone;

  BirthDetailsRequestModel();


  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'year': year.trim(),
      'month': month.trim(),
      'day': day.trim(),
      'hour': hour.trim(),
      'min': min.trim(),
      'lat': lat.trim(),
      'lon':lon.trim(),
      'tzone':tzone.trim(),

    };

    return map;
  }


}