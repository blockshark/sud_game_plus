import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sud_game_plus/sud_game_plus.dart';
import 'package:sud_game_plus_example/constants.dart';
import 'package:sud_game_plus_example/game_list_page.dart';
import 'package:sud_game_plus_example/live_page.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final liveTextCtrl =
  TextEditingController(text: Random().nextInt(10000).toString());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SudGamePlus.initSDK(MG_APPID, MG_APPKEY, MG_APP_IS_TEST_ENV);
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      fixedSize: const Size(150, 60),
      backgroundColor: Color.fromARGB(255, 17, 122, 111).withOpacity(0.6),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('SUD MiniGame Demo1',
                style: TextStyle(color: Colors.black, fontSize: 25)),
            const SizedBox(height: 100),
            Text('User ID:$localUserID'),
            const Text('Please test with two or more devices'),
            TextFormField(
              controller: liveTextCtrl,
              decoration: const InputDecoration(labelText: 'join a live by id'),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            // click me to navigate to LivePage
            ElevatedButton(
              style: buttonStyle,
              child: const Text(
                'Enter Room',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              onPressed: () => Get.to(()=> LivePage(liveID: liveTextCtrl.text, isHost: false)),
            ),
          ],
        ),
      ),
    );
  }

}
