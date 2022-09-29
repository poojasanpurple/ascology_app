class UserUpdateProfileRequest
{
  String name;
  String email;
  String gender;
  String short_description;
  String user_id;
  String date_birth;
  String place_birth;
  String time;
  String image;

  UserUpdateProfileRequest();



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name.trim(),
      'email': email.trim(),
      'gender': gender.trim(),
      'short_description': short_description.trim(),
      'user_id': user_id.trim(),
      'date_birth': date_birth.trim(),
      'place_birth': place_birth.trim(),
      'time': time.trim(),
      'image': image.trim(),
    };

    return map;
  }


}