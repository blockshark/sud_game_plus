import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sud_game_plus_platform_interface.dart';

/// An implementation of [SudGamePlusPlatform] that uses method channels.
class MethodChannelSudGamePlus extends SudGamePlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sud_game_plus');

  final _eventChannel = EventChannel('sud_game_event');

  @override
  EventChannel get enentChannel => _eventChannel;


  @override
  Future<Map?> getVersion() async {
    final version = await methodChannel.invokeMethod<Map?>('getVersion');
    return version;
  }

  @override
  Future<Map?> initSDK(String appid, String appkey, bool isTestEnv)async{
    return await methodChannel.invokeMethod("initSDK", {"appid": appid, "appkey": appkey, "isTestEnv": isTestEnv});
  }

  @override
  Future<Map?> getGameList()async{
    return await methodChannel.invokeMethod<Map?>("getGameList",{});
  }

  @override
  Future<Map?> loadGame(String userid, String roomid, String code, int gameid, String language, String viewSize, String gameConfig) async {
    return await methodChannel.invokeMethod("loadGame", {
      "userid": userid,
      "roomid": roomid,
      "code": code,
      "gameid": gameid,
      "language": language,
      "viewSize": viewSize,
      "gameConfig": gameConfig,
    });
  }

  @override
  Future<Map> pauseMG() async {
    return await methodChannel.invokeMethod("pauseMG", {});
  }

  @override
   Future<Map> playMG() async {
    return await methodChannel.invokeMethod("playMG", {});
  }

  @override
   Future<Map> updateCode(String code) async {
    return await methodChannel.invokeMethod("updateCode", {"code": code});
  }

  @override
   Future<Map?> destroyGame() async {
    return await methodChannel.invokeMethod<Map?>("destroyGame", {});
  }

  @override
   Future<Map?> notifyStateChange(String state, String dataJson) async {
    return await methodChannel.invokeMethod("notifyStateChange", {
      "state": state,
      "dataJson": dataJson,
    });
  }

}
