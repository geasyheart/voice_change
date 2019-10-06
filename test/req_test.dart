import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';


class ServerBaseMsg {
  int errCode ;
  String errMsg;
  Map<String, dynamic> data;

  ServerBaseMsg({this.errCode, this.errMsg, this.data});

  ServerBaseMsg.fromJson(Map<String, dynamic> json) {
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


Dio retrieveDio() {
  var dio = Dio(BaseOptions(
    baseUrl: "http://192.168.0.107:5000",
    connectTimeout: 5000,
    receiveTimeout: 5000,
//    contentType: ContentType()
  ));

  dio.interceptors.add(InterceptorsWrapper(onRequest: (Options options) async {
    dio.interceptors.requestLock.lock();

    options.headers["Token"] = "123321";
    dio.interceptors.requestLock.unlock();

    return options;
  }, onResponse: (Response response) {
    if (response.statusCode == 401) {
      // 表示未登录或者失效
      // todo: here2
    }
    return response;
  }, onError: (DioError e) {
    return e;
  }));

  return dio;
}

void main() {
  test("aa", () async {
    final dio = retrieveDio();
    try {
      final response = await dio.post("/api/v1/user/login");
    }catch(e){
      print(e.toString());
    }
  });


  test("bb", () async{
    final dio = retrieveDio();
    try{
      final response = await dio.get("/api/v1/user/info");
      final p = ServerBaseMsg.fromJson(response.data);
      print(p.errCode);
      print(p.errMsg);
      print(p.data);
    }catch(e){
      print(e.toString());
    }

  });


  test("sleep", () async{
    print("开始");
    sleep(Duration(seconds: 3));
    print("睡眠");
  });

}
