class BasicModel {
  int errCode;
  String errMsg;

  BasicModel({this.errCode, this.errMsg});

  BasicModel.fromJson(Map<String, dynamic> json) {
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