import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:voice_change/dao/video.dart';
import 'package:voice_change/g/Constant.dart';
import 'package:voice_change/g/env.dart';
import 'package:voice_change/widgets/share_widget.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
/*
视频播放
分享
 */

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  final ShareWidget shareModal = new ShareWidget();
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    if (globalEnv.videoPlayUrl != "") {
      print('播放来自服务器端的视频: ${globalEnv.videoPlayUrl}');
      _controller = VideoPlayerController.network(globalEnv.videoPlayUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    } else {
      print('竟然播放本地的文件了');
      _controller = VideoPlayerController.file(File(globalEnv.videoPath))
        ..initialize().then((_) {
          setState(() {});
        });
    }
    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
//      backgroundColor: Colors.black, // 目前忽略掉，如果有白边，再加回来
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              fit: StackFit.expand,
              // 这里目的是为了解决视频尺寸无法全屏的问题，如果默认能够全屏，那么不要使用Stack进行平铺。
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 66.0,
                    right: MediaQuery.of(context).viewInsets.right + 10.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.white),
                          ),
                          child: Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () async {
                          // TODO： 这里更换成视频处理后的地址
                          final file = File(globalEnv.videoPath);
                          var bytes = await file.readAsBytes();
                          await Share.file(
                              "分享视频",
                              globalEnv.videoPath.split("/").last,
                              bytes,
                              "video/mp4",
                              text: "分享好友一起来～");
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.white),
                          ),
                          child: Icon(
                            Icons.text_fields,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () async {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Container(
                                  height: 60.0,
                                  child: TextField(
                                    controller: textEditingController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        suffix: IconButton(
                                            padding:
                                            EdgeInsets.only(top: 12.0),
                                            icon: Icon(Icons.send),
                                            onPressed: () async {
                                              final String userInput =
                                                  textEditingController
                                                      .value.text;
                                              if (userInput != "") {
                                                try {
                                                  await VideoDao.correctText(
                                                      userInput,
                                                      globalEnv
                                                          .videoUniqueMark);
                                                } catch (e) {}
                                              }
                                              textEditingController.clear();
                                              Navigator.pop(context);
                                            })),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),

                      GestureDetector(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.white),
                          ),
                          child: Icon(
                            Icons.autorenew,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              INDEX_SCREEN, (Route<dynamic> route) => false);
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.white),
                          ),
                          child: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            // If the video is playing, pause it.
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              // If the video is paused, play it.
                              _controller.play();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
