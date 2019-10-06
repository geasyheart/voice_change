import 'package:voice_change/g/request.dart';
import 'package:voice_change/g/routers.dart';
import 'package:voice_change/model/peoples_model.dart';

class ChoicesPeoplesDao {
  static Future<ChoicesPeoples> retrievePeoples() async {
    // 获取人物列表
    final vDio = requestUtil.singleTonDIO();
    final response = await vDio.get(CHOICES_PEOPLE_ROUTER);
    return ChoicesPeoples.fromJson(response.data);
  }
}
