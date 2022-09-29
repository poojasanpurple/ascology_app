class UpdateStatusRequest
{
  String agent_id;
  String type;
  String status;

  UpdateStatusRequest();

/*  LoginRequestModel(this.email, this.password, this.token, this.device_name,
      this.device_model, this.apk_version, this.imei_number);*/

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'agent_id': agent_id.trim(),
      'type': type.trim(),
      'status': status.trim(),
    };
    return map;
  }
}