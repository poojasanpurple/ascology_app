class UserChatHistRequest
{
  String mobile;

  UserChatHistRequest();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'mobile': mobile.trim(),

    };

    return map;
  }


}