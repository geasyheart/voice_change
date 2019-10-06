import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voice_change/widgets/circle_widget.dart';

class CustomViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CustomViewPageState();
}

class CustomViewPageState extends State<CustomViewPage>
    with SingleTickerProviderStateMixin {
  Animation<double> _doubleAnimation;
  AnimationController _controller;
  CurvedAnimation curvedAnimation;

  final int recordMaxLimitTime = 30;

  bool _isPlaying = false;

  void onAnimationStart() {
    _controller.forward(from: 0.0);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: recordMaxLimitTime));
    curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    _doubleAnimation = Tween(begin: 0.0, end: 360.0).animate(_controller);

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CustomPaint(
                  painter: CircleProgressBarPainter(_doubleAnimation.value),
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            "${(_doubleAnimation.value / 360 * recordMaxLimitTime).round().toString()}",
                            style: TextStyle(fontSize: 10.0),
                          )),
                      GestureDetector(
                          onTap: () {
                            if (_isPlaying) {
                              _controller.stop();
                            } else {
                              _controller.forward();
                            }
                            ;
                            setState(() {
                              _isPlaying = !_isPlaying;
                            });
                          },
                          child: Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child:
                                    Image.asset('assets/images/avatars/5.png'),
                              ))),
                    ],
                  ),
                ))));
  }

//  @override
//  void reassemble() {
//    super.reassemble();
//    onAnimationStart();
//  }
}
