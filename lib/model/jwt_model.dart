class JwtHead {
  String alg;
  int iat;
  int exp;

  JwtHead({this.alg, this.iat, this.exp});

  JwtHead.fromJson(Map<String, dynamic> json) {
    alg = json['alg'];
    iat = json['iat'];
    exp = json['exp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alg'] = this.alg;
    data['iat'] = this.iat;
    data['exp'] = this.exp;
    return data;
  }
}