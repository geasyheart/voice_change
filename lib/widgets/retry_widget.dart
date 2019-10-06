import 'package:flutter/material.dart';

class RetryDialog {
  static Widget buildRetryDialog(VoidCallback v) {
    // TODO: 动作要想.....
    return new Center(
      child: new Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
          child: new InkWell(
            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            onTap: v,
            child: new Container(
              width: 200.0,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                  left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
              height: 48.0,
              decoration: new BoxDecoration(
                border: new Border.all(
                  width: 1.0,
                  color: Colors.blue,
                ),
                borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
              ),
              child: new Text('网络异常，请检查后重试'),
            ),
          )),
    );
  }
}
