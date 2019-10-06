/*
flutter 是single thread

存放此项目所有的公共变量
 */

import 'package:voice_change/g/utils.dart';
import 'package:voice_change/model/jwt_model.dart';
import 'package:voice_change/model/peoples_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalEnv {
  // ignore: non_constant_identifier_names
  final String SERVER_URL = "http://192.168.0.122:5000";

  /*
  允许录制的时间，最好偶数
   */
  // ignore: non_constant_identifier_names
  final int ALLOW_VIDEO_RECORD_SECONDS = 30;

  /*
  验证码delay时间
   */
  // ignore: non_constant_identifier_names
  final int DELAY_SECONDS = 10;

  /*
  用户信息相关的
   */
  Future<bool> setUserAuthTokenPersist(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool ok = await prefs.setString("userAuthToken", token);
    return ok;
  }

  Future<String> retrieveUserAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userAuthToken");
  }

  Future<bool> isLogin() async {
    String token = await this.retrieveUserAuthToken();
    if (token == "" || token == null) {
      return false;
    }
    try {
      JwtHead head = JwtHead.fromJson(parseJwt(token, 0));

      final int _timeStamp = DateTime.now().microsecondsSinceEpoch;
      if(head.exp * 1000000  > _timeStamp){
        return true;
      }else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /*
  当前录制的视频地址
   */
  String _videoPath = "";

  // ignore: unnecessary_getters_setters
  String get videoPath => _videoPath;

  // ignore: unnecessary_getters_setters
  set videoPath(String path) {
    _videoPath = path;
    print('[GlobalEnv] current video_path:$_videoPath');
  }

  /*
  视频上传成功后返回的唯一标志
   */
  String _videoUniqueMark  = "";


  // ignore: unnecessary_getters_setters
  String get videoUniqueMark => _videoUniqueMark;

  // ignore: unnecessary_getters_setters
  set videoUniqueMark(String mark){
    _videoUniqueMark = mark;
    print('[GlobalEnv] current videoUniqueMark:$_videoUniqueMark');
  }

  /*
  视频处理完后返回的视频地址
  https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4
   */

  String _videoPlayUrl = "";

  String get videoPlayUrl => _videoPlayUrl;


  set videoPlayUrl(String url){
    _videoPlayUrl = url;
    print('[GlobalEnv] current Video Url:$_videoPlayUrl');
  }


  /*
  选择的人物信息
   */
  ChoicePeoples _choicePeoples;

  // ignore: unnecessary_getters_setters
  ChoicePeoples get choicePeoples => _choicePeoples;

  // ignore: unnecessary_getters_setters
  set choicePeoples(ChoicePeoples people) {
    _choicePeoples = people;
    print('[GlobalEnv] current people: ${_choicePeoples.toString()}');
  }
}

final GlobalEnv globalEnv = GlobalEnv();
