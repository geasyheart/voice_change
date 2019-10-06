
## How to run

1. cd server/ && virtualenv -p python3 venv && source venv/bin/activate &&  pip install -r requirements.txt && python main.py
2. 修改g/env.dart中SERVER_URL地址到服务跑的地址，注意不是127.0.0.1
3. cd projectPath && flutter packages get
4. cd projectPath && flutter run


### 关于美颜
1. 看如何通信，要开发插件的...
2. 能不能直接抠出来现成的
   + [看能不能抠出来](https://www.muducloud.com/api/%E6%9C%8D%E5%8A%A1%E6%96%87%E6%A1%A3/%E8%A7%86%E9%A2%91%E4%BA%91%E6%9C%8D%E5%8A%A1/%E7%9B%B4%E6%92%AD%E6%9C%8D%E5%8A%A1/%E6%89%8B%E6%9C%BA%E6%8E%A8%E6%B5%81SDK/Flutter%20SDK%20%E6%96%87%E6%A1%A3.html)
   + 以及agora..


### 关于网络错误的处理

### 支付成功后,realod人物数据库信息


### [微信](https://study.163.com/course/courseLearn.htm?courseId=1209174838#/learn/video?lessonId=1278774028&courseId=1209174838)



### 问题

1. 添加登录页面，如果没有登录，则登录并跳转到支付页面，否则直接跳支付页面(finished)
2. 视频播放完上传视频，然后等待后端获取视频地址，跳转到播放页面
3. 分享是否能够直接分享视频
4. 支付
5. 美颜


关于录像分辨率低的问题，目前还没有合并...,相关issue:
[点我](https://github.com/flutter/plugins/pull/1403/files)
[点我](https://github.com/flutter/flutter/issues/29951)
W/VideoCapabilities( 7768): Unsupported mime video/divx
W/VideoCapabilities( 7768): Unsupported mime video/divx311



这个需要重写didUpdateWidget，怎么写？？
I/flutter (18287): ---------------------调试模式-----------------------
E/BufferQueueProducer(18287): [SurfaceTexture-0-18287-21] cancelBuffer: BufferQueue has been abandoned
E/BufferQueueProducer(18287): [SurfaceTexture-0-18287-21] cancelBuffer: BufferQueue has been abandoned
I/flutter (18287): #0      ChangeNotifier._debugAssertNotDisposed.<anonymous closure> (package:flutter/src/foundation/change_notifier.dart:105:9)
I/flutter (18287): #1      ChangeNotifier._debugAssertNotDisposed (package:flutter/src/foundation/change_notifier.dart:111:6)
I/flutter (18287): #2      ChangeNotifier.notifyListeners (package:flutter/src/foundation/change_notifier.dart:200:12)
I/flutter (18287): #3      ValueNotifier.value= (package:flutter/src/foundation/change_notifier.dart:270:5)
I/flutter (18287): #4      VideoPlayerController.pause (package:video_player/video_player.dart:304:5)
I/flutter (18287): <asynchronous suspension>
I/flutter (18287): #5      _VideoAppLifeCycleObserver.didChangeAppLifecycleState (package:video_player/video_player.dart:413:21)
I/flutter (18287): #6      _WidgetsFlutterBinding&BindingBase&GestureBinding&ServicesBinding&SchedulerBinding&PaintingBinding&SemanticsBinding&RendererBinding&WidgetsBinding.handleAppLifecycleStateChanged (package:flutter/src/widgets/binding.dart:521:16)
I/flutter (18287): #7      _WidgetsFlutterBinding&BindingBase&GestureBinding&ServicesBinding&SchedulerBinding._handleLifecycleMessage (package:flutter/src/scheduler
I/flutter (18287): ---------------------到此结束-----------------------

关于视频被拉伸

### 关于页面

1. 参考 [devefy](https://github.com/devefy)
2. 参考 [flutter-devs](https://github.com/flutter-devs)



