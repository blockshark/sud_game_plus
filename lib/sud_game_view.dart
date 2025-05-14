import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class SudGameView extends StatelessWidget {
  const SudGameView({super.key});

  @override
  Widget build(BuildContext context) {

    if (Platform.isIOS) {
      return UiKitView(
          key: UniqueKey(),
          viewType: 'SudMGPPluginView',
          onPlatformViewCreated: (int viewID) {

          });
    } else if (Platform.isAndroid) {
      const Map<String, dynamic> creationParams = <String, dynamic>{};
      return PlatformViewLink(
        viewType: 'SudMGPPluginView',
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (params) {
          return PlatformViewsService.initExpensiveAndroidView(
            id: params.id,
            viewType: 'SudMGPPluginView',
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..create();
        },
      );
    }
    return SizedBox();
  }
}
