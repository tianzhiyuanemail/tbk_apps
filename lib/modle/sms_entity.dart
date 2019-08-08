class SmsEntity {
	String code;
	String requestId;
	String bizId;
	String message;

	SmsEntity({this.code, this.requestId, this.bizId, this.message});

	SmsEntity.fromJson(Map<String, dynamic> json) {
		code = json['code'];
		requestId = json['requestId'];
		bizId = json['bizId'];
		message = json['message'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['code'] = this.code;
		data['requestId'] = this.requestId;
		data['bizId'] = this.bizId;
		data['message'] = this.message;
		return data;
	}
}
