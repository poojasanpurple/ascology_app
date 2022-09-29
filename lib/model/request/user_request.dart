class UserRequestModel
{
  String user_id;

  UserRequestModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'user_id': user_id.trim(),
    };

    return map;
  }


}