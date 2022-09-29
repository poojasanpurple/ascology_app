class ReviewRequestModel
{
  String comment;
  String agent_id;
  String current_user;
  String rating;

  ReviewRequestModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'comment': comment.trim(),
      'agent_id': agent_id.trim(),
      'current_user': current_user.trim(),
      'rating': rating.trim(),

    };

    return map;
  }


}