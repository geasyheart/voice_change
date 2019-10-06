import 'package:dio/dio.dart';

import '../device.dart';
import 'env.dart';

class RequestUtil {
  // 基本的dio
  final dio = Dio(BaseOptions(
    baseUrl: globalEnv.SERVER_URL,
  ));
  
  
  Dio singleTonDIO({withToken: true, withDeviceInfo: true}) {
    // 此处增加一个拦截器，用于封装网络失败和token认证
      dio.interceptors.add(InterceptorsWrapper(onRequest: (Options options) async {
        dio.interceptors.requestLock.lock();
        if(withToken) {
          final _token = await globalEnv.retrieveUserAuthToken();
          options.headers["Authorization"] = "Bearer $_token";
        }
        if(withDeviceInfo){
          final deviceInstallID = await deviceManager.retrieveDeviceID();
          final deviceKeyChainID = await deviceManager.retrieveKeyChainID();
          options.headers["DeviceInstallID"] = deviceInstallID;
          options.headers["DeviceKeyChainID"] = deviceKeyChainID;
        }
        dio.interceptors.requestLock.unlock();
        return options;
      }, onResponse: (Response response) async {
        return response;
      }, onError: (DioError e) {
        print('--------------网络请求遇到错误-------------');
        print(e.toString());
        print('--------------网络请求遇到错误-------------');
        return e;
      }));
    return dio;
  }
}

final requestUtil = new RequestUtil();
