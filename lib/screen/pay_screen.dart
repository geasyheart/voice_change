import 'package:flutter/material.dart';

/*
支付页面
支付成功后需要退回首页并且重新reload数据库
 */

class PayScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PayScreenState();
  }
}

class PayScreenState extends State<PayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("支付成功后更精彩~~")),
    );
  }
}
