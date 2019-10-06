import 'dart:async';
import 'dart:io';

import "package:dio/dio.dart";
import 'package:voice_change/g/request.dart';
import 'package:voice_change/g/routers.dart';
import 'package:voice_change/model/basic_model.dart';
import 'package:voice_change/model/video_model.dart';

class VideoDao {
  static Future<VideoUploadModel> upload(
      String filePath, double deviceWidth, double deviceHeight) async {
    // 上传
    final filename = filePath.split("/").last;

    final vDio = requestUtil.singleTonDIO();
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(new File(filePath), filename),
      "width": deviceWidth,
      "height": deviceHeight
    });

    final response = await vDio.post(VIDEO_UPLOAD_ROUTER, data: formData);
    return VideoUploadModel.fromJson(response.data);
  }

  static Future<VideoPlayModel> retrieveVideoPlayUrl(
      String videoUniqueMark) async {
    final vDio = requestUtil.singleTonDIO();
    final response = await vDio
        .post(VIDEO_RETRIEVE_PLAY_ROUTER, data: {"mark": videoUniqueMark});
    return VideoPlayModel.fromJson(response.data);
  }

  static Future<BasicModel> correctText(String text, String uniqueMark) async {
    print('用户输入:$text');
    final vDio = requestUtil.singleTonDIO();
    final response = await vDio.post(
      VIDEO_TEXT_ROUTER,
      data: {"text": text, "mark": uniqueMark},
    );
    return BasicModel.fromJson(response.data);
  }
}
