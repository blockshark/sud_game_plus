
import 'dart:async';

import 'sud_game_plus_platform_interface.dart';

class SudGamePlus {

  static SudGamePlus? _instance;

  factory SudGamePlus() => _sharedInstance();

  static SudGamePlus _sharedInstance() {
    _instance ??= SudGamePlus._internal();
    return _instance!;
  }
  static SudGamePlus get instance => _sharedInstance();

  SudGamePlus._internal(){
    eventStream = SudGamePlusPlatform.instance.enentChannel.receiveBroadcastStream().cast<Map>();
  }

  // void Function(Map map)? onEvent;
  Stream<Map>? eventStream;


  static Future<Map?> getVersion() {
    return SudGamePlusPlatform.instance.getVersion();
  }

  static Future<Map?> initSDK(String appid, String appkey, bool isTestEnv){
    return SudGamePlusPlatform.instance.initSDK(appid, appkey, isTestEnv);
  }

  static Future<Map?> getGameList() {
    return SudGamePlusPlatform.instance.getGameList();
  }

  static Future<Map?> loadGame(String userid, String roomid, String code, int gameid, String language, String viewSize, String gameConfig){
    return SudGamePlusPlatform.instance.loadGame(userid, roomid, code, gameid, language, viewSize, gameConfig);
  }

  static Future<Map> pauseMG() async {
    return SudGamePlusPlatform.instance.pauseMG();
  }

  static Future<Map> playMG() async {
    return SudGamePlusPlatform.instance.playMG();
  }

  static Future<Map> updateCode(String code) async {
    return SudGamePlusPlatform.instance.updateCode(code);
  }

  static Future<Map?> destroyGame() async {
    return SudGamePlusPlatform.instance.destroyGame();
  }

  static Future<Map?> notifyStateChange(String state, String dataJson) async {
    return SudGamePlusPlatform.instance.notifyStateChange(state, dataJson);
  }


}
