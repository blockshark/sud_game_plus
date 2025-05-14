import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sud_game_plus_method_channel.dart';

abstract class SudGamePlusPlatform extends PlatformInterface {
  /// Constructs a SudGamePlusPlatform.
  SudGamePlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static SudGamePlusPlatform _instance = MethodChannelSudGamePlus();

  /// The default instance of [SudGamePlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelSudGamePlus].
  static SudGamePlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SudGamePlusPlatform] when
  /// they register themselves.
  static set instance(SudGamePlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  EventChannel get enentChannel => throw UnimplementedError(' get enentChannel has not been implemented');

  Future<Map?> getVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map?> initSDK(String appid, String appkey, bool isTestEnv){
    throw UnimplementedError('initSDK() has not been implemented.');
  }

   Future<Map?> getGameList() {
    throw UnimplementedError('getGameList() has not been implemented.');
  }

  Future<Map?> loadGame(String userid, String roomid, String code, int gameid, String language, String viewSize, String gameConfig) async {
    throw UnimplementedError('loadGame() has not been implemented.');
  }

  Future<Map> pauseMG() async {
    throw UnimplementedError('pauseMG() has not been implemented.');
  }

  Future<Map> playMG() async {
    throw UnimplementedError('playMG() has not been implemented.');
  }

  Future<Map> updateCode(String code) async {
    throw UnimplementedError('updateCode() has not been implemented.');
  }

  Future<Map?> destroyGame() async {
    throw UnimplementedError('destroyGame() has not been implemented.');
  }

  Future<Map?> notifyStateChange(String state, String dataJson) async {
    throw UnimplementedError('notifyStateChange() has not been implemented.');

  }

}
