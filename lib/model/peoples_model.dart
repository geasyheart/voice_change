/*
从url拉取
 */

class ChoicesPeoples {
  Data data;
  int errCode;
  String errMsg;

  ChoicesPeoples({this.data, this.errCode, this.errMsg});

  ChoicesPeoples.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    errCode = json['errCode'];
    errMsg = json['errMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['errCode'] = this.errCode;
    data['errMsg'] = this.errMsg;
    return data;
  }
}

class Data {
  List<ChoicePeoples> choicePeoples;
  int lineCount;

  Data({this.choicePeoples, this.lineCount});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['choicePeoples'] != null) {
      choicePeoples = new List<ChoicePeoples>();
      json['choicePeoples'].forEach((v) {
        choicePeoples.add(new ChoicePeoples.fromJson(v));
      });
    }
    lineCount = json['lineCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.choicePeoples != null) {
      data['choicePeoples'] =
          this.choicePeoples.map((v) => v.toJson()).toList();
    }
    data['lineCount'] = this.lineCount;
    return data;
  }
}

class ChoicePeoples {
  String icon;
  bool lock;
  String name;

  ChoicePeoples({this.icon, this.lock, this.name});

  ChoicePeoples.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    lock = json['lock'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['lock'] = this.lock;
    data['name'] = this.name;
    return data;
  }
}


