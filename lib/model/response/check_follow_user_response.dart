

// to check that whether the logged in user
// is following the agent or not to show the follow button or grey out
class CheckFollowUser
{
  String id;
  String agent_id;
  String user_id;
  String agentname;

  CheckFollowUser();

  factory CheckFollowUser.fromJson(Map<String, dynamic> json) {
    CheckFollowUser followUser = new CheckFollowUser();
    followUser.id =  json["id"];
    followUser.agent_id =  json["agent_id"];
    followUser.user_id =  json["user_id"];
    followUser.agentname =  json["agentname"];

    return followUser;

  }
}