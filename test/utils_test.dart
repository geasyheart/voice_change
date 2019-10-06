import 'package:flutter_test/flutter_test.dart';
import 'package:voice_change/g/utils.dart';
import 'package:voice_change/model/jwt_model.dart';


void main() {
  test("aa", (){
    var token = 'eyJhbGciOiJIUzUxMiIsImlhdCI6MTU2MzM1MzcwMywiZXhwIjoxNTYzMzUzODAzfQ.eyJhIjoiYiJ9.3lUw4kK59RfVfKbrhDqlYxl5QFyZfp22mkUGJMYYclKxhRybMKTAi4sujiD9XvrMYJ_ljCLMNLFLuHpbKf00XQ';
    try {
      JwtHead head = JwtHead.fromJson(parseJwt(token, 0));

      final int _timeStamp = DateTime
          .now()
          .microsecondsSinceEpoch;
      if (head.exp * 1000000 > _timeStamp) {
        print('有效');
      } else {
        print('失效');
      }
    } catch (e) {
      print(e.toString());
    }
  });
}