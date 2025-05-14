package com.example.sud_game_plus

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import tech.sud.mgp.core.ISudFSTAPP

class NativeViewFactory (val activity: Activity): PlatformViewFactory(StandardMessageCodec.INSTANCE) {


    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return NativeView(activity)
    }

}