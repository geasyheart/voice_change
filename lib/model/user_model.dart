
class UserVerifyCode {
  int errCode;
  String errMsg;

  UserVerifyCode({this.errCode, this.errMsg});

  UserVerifyCode.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMsg = json['errMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMsg'] = this.errMsg;
    return data;
  }
}

class UserLogin {
  int errCode;
  String errMsg;
  String token;

  UserLogin({this.errCode, this.errMsg, this.token});

  UserLogin.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMsg = json['errMsg'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMsg'] = this.errMsg;
    data['token'] = this.token;
    return data;
  }
}