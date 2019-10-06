class VideoUploadModel {
  int errCode;
  String errMsg;
  String data;

  VideoUploadModel({this.errCode, this.errMsg, this.data});

  VideoUploadModel.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMsg = json['errMsg'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMsg'] = this.errMsg;
    data['data'] = this.data;
    return data;
  }
}




class VideoPlayModel {
  int errCode;
  String errMsg;
  String data;

  VideoPlayModel({this.errCode, this.errMsg, this.data});

  VideoPlayModel.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMsg = json['errMsg'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMsg'] = this.errMsg;
    data['data'] = this.data;
    return data;
  }
}