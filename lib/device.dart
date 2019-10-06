/*
和设备有关的
 */

import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceManager {
  // ignore: non_constant_identifier_names
  final String DEVICE_INSTALL_ID = "VoiceChangeDeviceInstallID";
  // ignore: non_constant_identifier_names
  final String DEVICE_KEYCHAIN_ID = "VoiceChangeDeviceKeyChain";

  Future<String> retrieveDeviceID() async {
    // 通过uuid唯一标识设备, 用于获取设备安装数量
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String _deviceInstallID = prefs.getString(DEVICE_INSTALL_ID);
    if (_deviceInstallID == "" || _deviceInstallID == null) {
      bool ok = await prefs.setString(DEVICE_INSTALL_ID, Uuid().v4());
      if (!ok) {
        throw Exception('retrieveDeviceID exception');
      }
      return prefs.getString(DEVICE_INSTALL_ID);
    }
    return _deviceInstallID;
  }

  Future<String> retrieveKeyChainID() async {
    // 通过KeyChain用于获取设备唯一标识
    final _deviceKeyChainID = await FlutterKeychain.get(key: DEVICE_KEYCHAIN_ID);
    if (_deviceKeyChainID == "" || _deviceKeyChainID == null) {
      await FlutterKeychain.put(key: DEVICE_KEYCHAIN_ID, value: Uuid().v4());
      return await FlutterKeychain.get(key: DEVICE_KEYCHAIN_ID);
    }
    return _deviceKeyChainID;
  }
}


/*
init:
flutter: 当前设备的安装ID为: 64e427d2-a4bf-4ec6-af43-f48261d8fa8d
flutter: 当前设备的keyChain为: b94ae318-98c6-466f-b211-a5b181f3c365

restart:
flutter: 当前设备的安装ID为: 64e427d2-a4bf-4ec6-af43-f48261d8fa8d
flutter: 当前设备的keyChain为: b94ae318-98c6-466f-b211-a5b181f3c365

reinstall:
flutter: 当前设备的安装ID为: 7d3e3a04-37f7-49ee-9009-1314722738af
flutter: 当前设备的keyChain为: b94ae318-98c6-466f-b211-a5b181f3c365

 */

final deviceManager = new DeviceManager();
