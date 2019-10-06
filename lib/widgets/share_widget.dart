import "package:flutter/material.dart";

class ShareWidget {
  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView(
            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '分享方式',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 150, 150, 150),
                      ),
                    )
                  ],
                ),
              ),
              createShareLine(context),
            ],
          );
        });
  }


  createShareLine(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GestureDetector(
          child: Container(
              height: 80.0,
              width: 80.0,
              child: Image.asset(
                "assets/images/share/wechat/logo.png",
                height: 64.0,
                width: 64.0,
              )),
          onTap: () {
            _shareToFriend();
            Navigator.pop(context);
          },
        ),
        GestureDetector(
          child: Container(
              height: 80.0,
              width: 80.0,
              child: Image.asset(
                "assets/images/share/wechat/moments.png",
                height: 64.0,
                width: 64.0,
              )),
          onTap: () {
            _shareToMoment();
            Navigator.pop(context);
          },
        ),
        GestureDetector(
          child: Container(
              height: 80.0,
              width: 80.0,
              child: Image.asset(
                "assets/images/share/wechat/collect.png",
                height: 64.0,
                width: 64.0,
              )),
          onTap: () {
            _shareToCollect();
            Navigator.pop(context);
          },
        ),
      ],
    ));
  }

  _shareToFriend(){
    // 分享给朋友

  }


  _shareToMoment(){
    // 分享给朋友圈

  }

  _shareToCollect() {
    // 收藏
  }

}
