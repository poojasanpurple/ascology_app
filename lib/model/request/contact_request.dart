class ContactRequestModel
{
  String email;
  String name;
  String mobile;
  String subject;
  String message;


  ContactRequestModel();

/*  LoginRequestModel(this.email, this.password, this.token, this.device_name,
      this.device_model, this.apk_version, this.imei_number);*/

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email.trim(),
      'name': name.trim(),
      'mobile': mobile.trim(),
      'subject': subject.trim(),
      'message': message.trim(),

    };

    return map;
  }
}