// Flutter imports:
import 'dart:async';
import 'dart:convert';
// import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sud_game_plus/sud_game_plus.dart';
import 'package:sud_game_plus/sud_game_view.dart';
import 'package:sud_game_plus_example/constants.dart';
import 'package:sud_game_plus_example/game_list_page.dart';
import 'game_utils.dart';


class LivePage extends StatefulWidget {
  final String liveID;
  final bool isHost;

  const LivePage({
    Key? key,
    required this.liveID,
    this.isHost = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LivePageState();
}

class LivePageState extends State<LivePage> {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  StreamSubscription<Map>? _streamSubscription;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("addPostFrameCallback callback");
    });
    _streamSubscription = SudGamePlus.instance.eventStream?.listen((data){
      String method = data['method'];
      String state = data['dataJson']['state'];
      print('method = $method,state = $state');
      switch (method) {
        case 'onGameStarted':
          setState(() {});
          break;
        case 'onGameDestroyed':
          break;
        case 'onGameStateChange':
          break;
        case 'onGetGameCfg':
          break;
        case 'onPlayerStateChange':
          break;
        case 'onExpireCode':
          break;
        default:
      }
    });

  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.blue, // Background color for gameView
            child: SudGameView(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 34,
              width: 88,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              margin: EdgeInsets.only(bottom: 44),
              child: InkWell(
                onTap: ()async{
                 final result = await Get.bottomSheet<int?>(GameListBottom());
                 if (result != null) {
                   final code = await getAuthCode();
                   if (code != null) {
                     await SudGamePlus.loadGame(localUserID, widget.liveID, code, result, "en-US", getGameViewSize(),  getGameConfig());
                     setState(() {

                     });
                   }
                 }
                },child: Center(
                child: Text('游戏列表'),
              ),),
            ),
          )
      ],
      ),
    );
  }


  Future<String?> getAuthCode()async {
       final response =  await postRequest(MG_NAME_LOGIN_AUTH_URL, '/login/v3', {'user_id': localUserID, 'app_id': MG_APPID});
      if (response['ret_code'] == 0) {
        return response['data']['code'];
      }
      return null;
  }

  String getGameViewSize() {
    final double scale = widgetsBinding.window.devicePixelRatio;
    final screenWidth = MediaQuery.of(context).size.width * widgetsBinding.window.devicePixelRatio;
    final screenHeight = MediaQuery.of(context).size.height * widgetsBinding.window.devicePixelRatio * 1.0;

    final top = scale * 100; // margin
    final bottom = scale * 200; // margin
    return json.encode({
      "view_size": {"width": screenWidth, "height": screenHeight},
      "view_game_rect": {"left": 0, "top": top, "right": 0, "bottom": bottom}
    });
  }

  String getGameConfig() {
    return json.encode({});
  }


}
