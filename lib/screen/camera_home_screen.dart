import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_change/dao/video.dart';
import 'package:voice_change/g/Constant.dart';
import 'package:voice_change/g/env.dart';
import 'package:voice_change/model/video_model.dart';
import 'package:voice_change/widgets/circle_widget.dart';

class CameraHomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraHomeScreen(this.cameras);

  @override
  State<StatefulWidget> createState() {
    return _CameraHomeScreenState();
  }
}

class _CameraHomeScreenState extends State<CameraHomeScreen>
    with TickerProviderStateMixin {
  String videoPath;
  bool _toggleCamera = false;

  CameraController controller;

  // 画圈圈用的
  Animation<double> _doubleAnimation;
  AnimationController _controller;
  CurvedAnimation curvedAnimation;

  bool isRetrieveVideoUrl = false;

  @override
  void initState() {
    // 优先选择前置摄像头
    onCameraSelected(widget.cameras[1]);
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameras.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(
          '没有发现相机',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      );
    }

    if (!controller.value.isInitialized) {
      return Container();
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: Container(
        child: Stack(
          children: <Widget>[
            CameraPreview(controller),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 180.0,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
//                color: Color.fromRGBO(00, 00, 00, 0.7),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FloatingActionButton(
                            heroTag: "search_btn",
                            focusColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            highlightElevation: 0,
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  INDEX_SCREEN, (Route<dynamic> route) => false);
                            },
                            child: Icon(Icons.search, size: 40,)
                        ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                onTap: () {
                                  _recordVideo();
                                },
                                child: CustomPaint(
                                  painter: CircleProgressBarPainter(
                                      _doubleAnimation.value),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 0,
                                        width: 0,
                                        child: Text(
                                          "${(_doubleAnimation.value / 360 * globalEnv.ALLOW_VIDEO_RECORD_SECONDS).round().toString()}",
                                        ),
                                      ),
                                      Container(
                                        width: 80,
                                        height: 80,
//                                    decoration: BoxDecoration(
//                                        shape: BoxShape.circle,
//                                        border: Border.all(
//                                            width: 5, color: Colors.white)),
                                        child: Image.asset(
                                          globalEnv.choicePeoples.icon ??
                                              'assets/images/ic_shutter_1.png',
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: FloatingActionButton(
                            heroTag: "switch_camera_btn",
                            focusColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            highlightElevation: 0,
                            onPressed: () {
                              if (!_toggleCamera) {
                                onCameraSelected(widget.cameras[0]);
                              } else {
                                onCameraSelected(widget.cameras[1]);
                              }
                              _toggleCamera = !_toggleCamera;
                            },
                            child: Icon(Icons.camera),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FloatingActionButton(
                        heroTag: "beauty_btn",
                        focusColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        highlightElevation: 0,
                        onPressed: () {
                          print('不支持美颜功能~~~');
                        },
                        // 脸显大。。。
                        child: Icon(Icons.face , size: 37,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 显示上传加载条
            Opacity(
              opacity: isRetrieveVideoUrl? 1 : 0,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onCameraSelected(CameraDescription cameraDescription,
      {bool reRecord = false}) async {
    // 如果视频正在录制中进行切换摄像头，那么则返回
    if (!reRecord && controller != null && controller.value.isRecordingVideo) {
      print('正在录制中，无法进行切换摄像头!');
      return;
    }

    if (controller != null) await controller.dispose();
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.veryHigh,
      enableAudio: true,
    );

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        print('Camera Error: ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e.toString());
    }

//    if (mounted) setState(() {});

    // 初始化canvas
    _controller?.dispose();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: globalEnv.ALLOW_VIDEO_RECORD_SECONDS));
    curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    _doubleAnimation = Tween(begin: 0.0, end: 360.0).animate(_controller);

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
        if (_doubleAnimation.value == 360.0) {
          onStopButtonPressed();
        }
      }
    });
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _recordVideo() async {
    if (controller.value.isRecordingVideo) {
      // 此处目前不做任何事情
      print('正在录制中');
    } else {
      // 开始录制
      await startVideoRecording();
    }
  }

  Future<void> _toPlay() async {
    // mounted为了解决当强行回到首页时报错
    if (mounted) {
      await Navigator.of(context).pushNamedAndRemoveUntil(
          VIDEO_PLAYER_SCREEN, (Route<dynamic> route) => false);
    }
  }

  Future sleep() {
    //  睡一秒
    return new Future.delayed(const Duration(seconds: 1), () => "");
  }

  Future<void> onStopButtonPressed() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }
    await controller.stopVideoRecording();
    globalEnv.videoPath = videoPath;
    // 重置上一条
    globalEnv.videoPlayUrl = "";
    try {
      final _info = await VideoDao.upload(
        videoPath,
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      );

      globalEnv.videoUniqueMark = _info.data;
      // 等待视频地址，url，非uniqueMark
      var _retryCount = 0;

      while (true) {
        if (_retryCount > 30) {
          print('视频获取超时');
          break;
        }
        VideoPlayModel _data =
            await VideoDao.retrieveVideoPlayUrl(globalEnv.videoUniqueMark);
        if (_data.errCode != 0) {
          print("服务器返回状态码:${_data.errCode}, 描述信息: ${_data.errMsg}");
          _retryCount += 1;
//          sleep(Duration(seconds: 1));
          await sleep();
          // 减少重绘页面次数
          if (!isRetrieveVideoUrl) {
            setState(() {
              isRetrieveVideoUrl = true;
            });
          }
        } else {
          globalEnv.videoPlayUrl = _data.data;
          break;
        }
      }
    } catch (e) {
      // todo： 表示上传失败，怎么处理？？
    }

    // 这里根据唯一标志拿到视频的转换后的结果

    await _toPlay();
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    // todo: 保存到相册，更新：目前关于path_provider只提供了两个接口，并且都无法保存到公共位置.
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/voice_change/Movies';
    await Directory(dirPath).create(recursive: true);
    videoPath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      return null;
    }
    try {
      await controller.startVideoRecording(videoPath);
    } catch (e) {
      print(e.toString());
    }
    // 进度条
    _controller.forward();

    return videoPath;
  }
}
