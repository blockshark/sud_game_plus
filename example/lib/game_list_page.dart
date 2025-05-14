import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sud_game_plus/sud_game_plus.dart';
import 'package:sud_game_plus_example/game_utils.dart';

class GameListBottom extends StatefulWidget {
  const GameListBottom({super.key});

  @override
  State<GameListBottom> createState() => _GameListBottomState();
}

class _GameListBottomState extends State<GameListBottom> {

  List<GameInfo> gameList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGameList();
  }
  Future<void> getGameList()async{
    final responses = await SudGamePlus.getGameList();
    print('responses = $responses');
    final errorCode = responses?['errorCode'] as int;
    if (errorCode == 0) {
      final dataJson = responses?['dataJson'] as String?;
      if (dataJson?.isNotEmpty ?? false) {
        try{
          final json = jsonDecode(dataJson!);

          final mg_info_list = json['data']?['mg_info_list'] as List?;
          if (mg_info_list != null) {
            setState(() {
              gameList = mg_info_list.map((e)=> GameInfo.fromJson(e)).toList();
            });
          }
        }catch(e){
          print('error = $e');
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 400,
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))
        ),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Text('请选择游戏'),
            Expanded(child: ListView.builder(itemCount:gameList.length,itemBuilder: (context,index){
              final item = gameList[index];
              // final thum = item['thumbnail128x128']['default'] as String;
              // final title = item['name']?['default'];
              // final mg_id = item['mg_id'] as int?;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                margin: EdgeInsets.symmetric(vertical: 5),
                child: InkWell(
                  onTap: ()async{
                    await SudGamePlus.pauseMG();
                    await SudGamePlus.destroyGame();
                    Navigator.of(context).pop(item.mg_id);
                  },
                  child:  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(item.thumbnail128x128,width: 44,height: 44,),
                      SizedBox(width: 10,),
                      Expanded(child: Text(item.name))
                    ],
                  ),
                ),
              );
            }))
          ],
        ),
      ),
    );
  }

}
