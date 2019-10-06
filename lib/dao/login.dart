import 'package:voice_change/g/env.dart';
import 'package:voice_change/g/request.dart';
import 'package:voice_change/g/routers.dart';
import 'package:voice_change/model/user_model.dart';

class LoginDao {
  static Future<UserVerifyCode> retrieveVerifyCode(String phoneNumber) async {
    print('开始获取手机验证码:$phoneNumber');
    final vDio = requestUtil.singleTonDIO();
    final response = await vDio
        .post(RETRIEVE_VERIFY_CODE_ROUTER, data: {"phone": phoneNumber});
    return UserVerifyCode.fromJson(response.data);
  }

  static Future<UserLogin> phoneLogin(
      String phoneNumber, String verifyCode) async {
    //  登录
    print('用户开始登录:$phoneNumber, $verifyCode');

    final vDio = requestUtil.singleTonDIO();

    final response = await vDio.post(USER_LOGIN_ROUTER,
        data: {"phone": phoneNumber, "verifyCode": verifyCode});
    final _data = UserLogin.fromJson(response.data);
    if (_data.errCode == 0) {
      await globalEnv.setUserAuthTokenPersist(_data.token);
    }
    return _data;
  }
}
