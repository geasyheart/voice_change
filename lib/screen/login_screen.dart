import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_change/dao/login.dart';
import 'package:voice_change/g/Constant.dart';
import 'package:voice_change/g/env.dart';
import 'package:voice_change/g/utils.dart';
import 'package:voice_change/model/menu_model.dart';
import 'package:voice_change/model/user_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  String _phoneNum = '';
  String _verifyCode = '';
  int _seconds = 0;
  String _verifyStr = '获取验证码';
  String _phoneErrorText;
  Timer _timer;

  String _loginFailMsg = '';

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  _startTimer() {
    _seconds = globalEnv.DELAY_SECONDS;

    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        return;
      }

      _seconds--;
      _verifyStr = '$_seconds s';
      if (_seconds == 0) {
        _verifyStr = '重新发送';
      }
      setState(() {

      });
    });
  }

  _cancelTimer() {
    _timer?.cancel();
  }

  Widget _buildPhoneEdit() {
    var node = new FocusNode();
    return new Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
      child: new TextField(
            onChanged: (text) {
              _phoneNum = text;
              if (isValidPhoneNumber(text)) {
                setState(() {
                  _phoneErrorText = null;
                });
              }
            },
            decoration: new InputDecoration(
              hintText: '手机号',
              errorText: _phoneErrorText,
            ),
            maxLines: 1,
            maxLength: 11,
            //键盘展示为号码
            keyboardType: TextInputType.phone,
            //只能输入数字
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            onSubmitted: (text) {
              FocusScope.of(context).requestFocus(node);
            },
          )
    );
  }

  Widget _buildVerifyCodeEdit() {
    var node = new FocusNode();
    Widget verifyCodeEdit = Container(
      margin: EdgeInsets.all(0),
      width: MediaQuery.of(context).size.width - 190,
      child: new TextField(
        onChanged: (text) {
          _verifyCode = text;
          setState(() {});
        },
        decoration: new InputDecoration(
          hintText: '短信验证码',
        ),
        maxLines: 1,
        maxLength: 6,
        //键盘展示为数字
        keyboardType: TextInputType.number,
        //只能输入数字
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        onSubmitted: (text) {
          FocusScope.of(context).requestFocus(node);
        },
      ),
    );

    Widget verifyCodeBtn = new InkWell(
      onTap: () {
        if (!isValidPhoneNumber(_phoneNum)) {
          setState(() {
            _phoneErrorText = "请输入有效的手机号！";
          });
        } else {
          setState(() {
            _phoneErrorText = null;
          });
          if (_seconds == 0) {
            setState(() {
              _startTimer();
            });
            LoginDao.retrieveVerifyCode(_phoneNum);
          }
        }
      },
      child: new Container(
        alignment: Alignment.center,
        width: 80.0,
        height: 36.0,
        decoration: new BoxDecoration(
          border: new Border.all(
            width: 1.0,
            color: Colors.grey,
          ),
        ),
        child: new Text(
          '$_verifyStr',
          style: new TextStyle(fontSize: 12.0),
        ),
      ),
    );

    return new Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 40.0, top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          verifyCodeEdit,
          verifyCodeBtn,
        ],
      ),
    );
  }

  Widget _buildErrors() {
    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, //子组件的排列方式为主轴两端对齐
        children: <Widget>[
          new Text(
            _loginFailMsg,
            style: new TextStyle(fontSize: 14.0, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildLogin() {
    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
      child: new RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        disabledColor: Colors.black12,
        onPressed: (_phoneNum.isEmpty ||
                _verifyCode.isEmpty ||
                !isValidPhoneNumber(_phoneNum))
            ? null
            : () async {
                if (!isValidPhoneNumber(_phoneNum)) {
                  setState(() {
                    _phoneErrorText = "请输入有效的手机号";
                  });
                  return;
                }
                final UserLogin _data =
                    await LoginDao.phoneLogin(_phoneNum, _verifyCode);

                if (_data.errCode != 0) {
                  setState(() {
                    _loginFailMsg = _data.errMsg;
                  });
                } else {
                  Navigator.of(context).pushReplacementNamed(INDEX_SCREEN);
                }
              },
        child: new Text(
          "登  录",
          style: new TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildThirdPartLogin() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: menus_login.map((Menu m) {
        return new GestureDetector(
          onTap: () {
            switch (m.index) {
              case 0:
                print('点击了微信');
                break;
              case 1:
                print('点击了新浪微博');
                break;
            }
          },
          child: new Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, top: 60.0, bottom: 12.0, right: 24.0),
              child: new Image.asset(
                m.icon,
                width: 60.0,
                height: 60.0,
              )),
        );
      }).toList(),
    );
  }

  Widget _buildProtocol() {
    return new Padding(
      padding: const EdgeInsets.only(
          left: 40.0, right: 40.0, top: 10.0, bottom: 20.0),
      child: new Container(
        child: new Text.rich(
          new TextSpan(
              text: '注册变声代表你已阅读并同意 ',
              style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400),
              children: [
                new TextSpan(
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        print('点击了变声协议');
                      },
                    text: '变声协议',
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                    )),
                new TextSpan(
                    text: ' 和 ',
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w400,
                    )),
                new TextSpan(
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        print('点击了隐私政策');
                      },
                    text: '隐私政策',
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                    )),
              ]),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return new ListView(
      children: <Widget>[
        _buildPhoneEdit(),
        _buildVerifyCodeEdit(),
        _buildLogin(),
        _buildErrors(),
        _buildThirdPartLogin(),
        _buildProtocol(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("登 录"),
          centerTitle: true,
        ),
        body: _buildBody(),
      ),
    );
  }
}
