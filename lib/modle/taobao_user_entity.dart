class TaobaoUserEntity {
  String avatarUrl;
  String nick;
  String openId;
  String openSid;
  String topAccessToken;
  String topAuthCode;

  TaobaoUserEntity(
      {this.avatarUrl,
      this.nick,
      this.openId,
      this.openSid,
      this.topAccessToken,
      this.topAuthCode});

  TaobaoUserEntity.fromJson(Map<String, dynamic> json) {
    avatarUrl = json['avatarUrl'];
    nick = json['nick'];
    openId = json['openId'];
    openSid = json['openSid'];
    topAccessToken = json['topAccessToken'];
    topAuthCode = json['topAuthCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatarUrl'] = this.avatarUrl;
    data['nick'] = this.nick;
    data['openId'] = this.openId;
    data['openSid'] = this.openSid;
    data['topAccessToken'] = this.topAccessToken;
    data['topAuthCode'] = this.topAuthCode;
    return data;
  }
}
