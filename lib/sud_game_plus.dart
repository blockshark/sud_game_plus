
import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

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

  static Future<Map?> loadGame(String userid, String roomid, String code, int gameid,BuildContext context,{String? language, String? viewSize, String? gameConfig}){
    viewSize ?? getGameViewSize(context);
    gameConfig ?? getGameConfig();

    Locale locale = Localizations.localeOf(context);
    final languageCode = locale.languageCode;
    Map languageMap = {
      'en':'en-US',
      'zh':"zh-TW",
    };
    final language = languageMap['languageCode'] ?? 'en-US';
    return SudGamePlusPlatform.instance.loadGame(userid, roomid, code, gameid, language, viewSize!, gameConfig!);
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

  static String getGameViewSize(BuildContext context,{double? width,double? height}) {

    final double scale = View.of(context).devicePixelRatio;
    final screenWidth = width ?? MediaQuery.of(context).size.width * scale;
    final screenHeight = height ?? MediaQuery.of(context).size.height * scale * 1.0;

    final top = scale * 100; // margin
    final bottom = scale * 200; // margin
    return json.encode({
      "view_size": {"width": screenWidth, "height": screenHeight},
      "view_game_rect": {"left": 0, "top": top, "right": 0, "bottom": bottom}
    });
  }

  static String getGameConfig() {
    return json.encode({});
  }

}
