class UserPaymentRequestModel
{
  String amount;
  String user_id;
  String invoice_num;
  String payment_mode;
  String payment_status;
  String payment_id;
  String payment_date;
  String mobile;
  String email;
  String user_name;

  UserPaymentRequestModel();

/*  LoginRequestModel(this.email, this.password, this.token, this.device_name,
      this.device_model, this.apk_version, this.imei_number);*/

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'amount': amount.trim(),
      'user_id': user_id.trim(),
      'invoice_num': invoice_num.trim(),
      'payment_mode': payment_mode.trim(),
      'payment_status': payment_status.trim(),
      'payment_id': payment_id.trim(),
      'payment_date': payment_date.trim(),
      'mobile': mobile.trim(),
      'email': email.trim(),
      'user_name': user_name.trim(),
    };

    return map;
  }
}