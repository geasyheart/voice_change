import 'package:flutter/material.dart';

class ProgressDialog {
  static Widget buildProgressDialog() {
    // 显示加载进度
    return new Center(child: new CircularProgressIndicator());
  }
}
