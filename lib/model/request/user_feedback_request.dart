class UserFeedbackModel
{
  String user_id;
  String description;


  UserFeedbackModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'user_id': user_id.trim(),
      'description': description.trim(),

    };

    return map;
  }


}