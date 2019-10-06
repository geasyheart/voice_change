import "package:flutter/material.dart";
import 'package:voice_change/g/Constant.dart';
import 'package:voice_change/g/env.dart';
import 'package:voice_change/model/peoples_model.dart';

class PeoplesNav extends StatelessWidget {
  final List<ChoicePeoples> lineChoicePeoples;

  const PeoplesNav({Key key, this.lineChoicePeoples}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = List.generate(
        lineChoicePeoples.length,
        (int index) => ChoicePeoplesNav(
              choicePeople: lineChoicePeoples[index],
            ));
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: children)
        ],
      ),
    );
  }
}

class ChoicePeoplesNav extends StatelessWidget {
  final ChoicePeoples choicePeople;

  const ChoicePeoplesNav({Key key, this.choicePeople}) : super(key: key);

  Widget build(BuildContext context) {
    void _freshPeopleInfo(ChoicePeoples people) {
      globalEnv.choicePeoples = people;
    }

    Future _openCamera() async {
      await Navigator.of(context).pushNamed(CAMERA_SCREEN);
    }

    Future _toPay() async {
      final _isLogin = await globalEnv.isLogin();

      if(_isLogin){
        await Navigator.of(context).pushNamed(PAY_SCREEN);
      }else{
        await Navigator.of(context).pushNamed(LOGIN_SCREEN);
      }
    }

    if (choicePeople.lock) {
      return GestureDetector(
        onTap: () {
          _freshPeopleInfo(choicePeople);
          _toPay();
        },
        child: Container(
          width: 80.0,
          height: 80.0,
          decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: new AssetImage(choicePeople.icon),
              )),
          child: Icon(Icons.lock),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          _freshPeopleInfo(choicePeople);
          _openCamera();
        },
        child: Container(
          width: 80.0,
          height: 80.0,
          decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: new AssetImage(choicePeople.icon),
              )),
        ),
      );
    }
  }
}
