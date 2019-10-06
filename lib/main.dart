import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_change/screen/camera_home_screen.dart';
import 'package:voice_change/screen/index_screen.dart';
import 'package:voice_change/screen/login_screen.dart';
import 'package:voice_change/screen/pay_screen.dart';
import 'package:voice_change/screen/splash_screen.dart';
import 'package:voice_change/screen/video_player_screen.dart';

import 'device.dart';
import 'g/constant.dart';

List<CameraDescription> cameras;
// 生产环境
//Future<void> main() async {
//  FlutterError.onError = (FlutterErrorDetails details) async {
//    if (isInDebugMode) {
//      // In development mode simply print to console.
//      FlutterError.dumpErrorToConsole(details);
//    } else {
//      // In production mode report to the application zone to report to
//      // Sentry.
//      Zone.current.handleUncaughtError(details.exception, details.stack);
//    }
//  };
//
//
//
//  try {
//    cameras = await availableCameras();
//  } on CameraException catch (e) {
//    print(e.description);
//    rethrow;
//  }
//
//  runZoned<Future<Null>>(() async {
//    runApp(new SingleAPP());
//  }, onError: (error, stackTrace) async {
//    await reportError(error, stackTrace);
//  });
//
//}

// 开发环境
Future<void> main() async {
  try {
    final deviceInstallID = await deviceManager.retrieveDeviceID();
    print('当前设备的安装ID为: $deviceInstallID');
    final deviceKeyChainID = await deviceManager.retrieveKeyChainID();
    print('当前设备的keyChain为: $deviceKeyChainID');
    cameras = await availableCameras();
  } catch (e) {
    print(e.toString());
  }

  runApp(SingleAPP());
}

class SingleAPP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 强制竖屏，在录制页面会有拉伸现象,听说orientations库更好，目前先略过.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: "变声",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
//      home: CustomViewPage(),
      routes: <String, WidgetBuilder>{
        LOGIN_SCREEN: (BuildContext context) => LoginScreen(),
        INDEX_SCREEN: (BuildContext context) => IndexScreen(),
        CAMERA_SCREEN: (BuildContext context) => CameraHomeScreen(cameras),
        VIDEO_PLAYER_SCREEN: (BuildContext context) => VideoPlayerScreen(),
        PAY_SCREEN: (BuildContext context) => PayScreen(),
      },
    );
  }
}
