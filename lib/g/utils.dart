import 'dart:convert';

List splitList(List<dynamic> a, length) {
  // 对数组进行切片
  var result = [];
  List _result;
  _subList(start, end) {
    try {
      return a.sublist(start, end);
    } catch (RangeError) {
      return a.sublist(start, a.length);
    }
  }

  final count = a.length ~/ length + 1;

  for (var i = 0; i < count; i++) {
    _result = _subList(i * length, (i + 1) * length);
    if (_result.length != 0) {
      result.add(_result);
    }
  }
  return result;
}

//
//void main(){
//  var a = [1,2,3,4,5];
//  var result = List.generate(a.length, (int index) => {"${a[index]}, 123" });
//  print(result);
//  a.forEach((i){
//    return "${a} 123";
//  });
//  for (var i in [1,2,3,4,5,6,7]){
//    print("$i, ${splitList(a, i)}");
//  }
//}

bool isValidPhoneNumber(String phoneNumber) {
  if (phoneNumber.startsWith("1") && phoneNumber.length == 11) {
    return true;
  }
  return false;
}

Map<String, dynamic> parseJwt(String token, int index) {

  // 获取jwt的明文信息
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }



  final payload = _decodeBase64(parts[index]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }

  return payloadMap;
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}





//void main(){
//  var token = 'eyJhbGciOiJIUzUxMiIsImlhdCI6MTU2MzM1MDAxOSwiZXhwIjoxNTYzMzUwMDI5fQ.eyJhYSI6ImJiYiJ9.JwYC_68pSl-oQso8mcpqYvuNyBOSsP26HJdATdlE5HcwXSJTNcTUISTs_tSAjPEX2qsHdevnmXq3ER8XRmZKiw';
//  final head = parseJwt(token, 0);
//  final payload = parseJwt(token, 1);
//  print(head.);
//  print(payload);
//}