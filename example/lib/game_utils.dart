import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class GameInfo {
  int mg_id;
  String name;
  String desc = '';
  String thumbnail80x80 = '';
  late String thumbnail332x332;
  late String thumbnail192x192;
  late String thumbnail128x128;
  late String bigLoadingPic;
  late int minCount;
  late int maxCount;

  GameInfo(this.mg_id, this.name);

  GameInfo.fromJson(Map<String, dynamic> json)
      : desc = json['desc']['default'],
        minCount = json['game_mode_list'][0]['count'][0],
        maxCount = json['game_mode_list'][0]['count'][1],
        thumbnail332x332 = json['thumbnail332x332']['default'],
        thumbnail192x192 = json['thumbnail192x192']['default'],
        thumbnail128x128 = json['thumbnail128x128']['default'],
        thumbnail80x80 = json['thumbnail80x80']['default'],
        bigLoadingPic = json['big_loading_pic']['default'],
        name = json['name']['default'],
        mg_id = json['mg_id'];
}


Future<Map<String, dynamic>> getRequest(String url, String api, Map<String, dynamic> jsonMap) async {
  HttpClient httpClient = HttpClient();
  var uri = Uri.https(url, api, jsonMap);
  HttpClientRequest request = await httpClient.getUrl(Uri.parse(uri.toString()));
  request.headers.set('content-type', 'application/json');
  HttpClientResponse response = await request.close();
  print("kaniel, http status:" + response.statusCode.toString());
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  Map<String, dynamic> map = json.decode(reply);
  return map;
}

Future<Map<String, dynamic>> postRequest(String url, String api, Map<String, dynamic> jsonMap) async {
  HttpClient httpClient = HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url + api));
  request.headers.set('Content-Type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  print("kaniel, http status:" + response.statusCode.toString());
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  Map<String, dynamic> map = json.decode(reply);
  return map;
}
