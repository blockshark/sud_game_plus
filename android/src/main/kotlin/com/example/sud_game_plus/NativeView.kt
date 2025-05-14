package com.example.sud_game_plus

import android.app.Activity
import android.app.Application
import android.view.View
import android.widget.FrameLayout
import io.flutter.plugin.platform.PlatformView
import android.os.Bundle
import android.util.Log
import tech.sud.mgp.core.ISudFSTAPP


class NativeView(val activity: Activity): PlatformView{

    private val view: FrameLayout = FrameLayout(activity).apply {

    }

    private val lifecycleCallbacks = object : Application.ActivityLifecycleCallbacks {
        override fun onActivityResumed(act: Activity) {
            if (act == activity) {
                GameManager.get().playMG()
            }
        }

        override fun onActivityPaused(act: Activity) {
            if (act == activity) {
                GameManager.get().pauseMG()
            }
        }

        // 可选实现其他方法
        override fun onActivityCreated(p0: Activity, p1: Bundle?) {}
        override fun onActivityStarted(p0: Activity) {}
        override fun onActivityStopped(p0: Activity) {}
        override fun onActivitySaveInstanceState(p0: Activity, p1: Bundle) {}
        override fun onActivityDestroyed(p0: Activity) {}
    }

    init {
        activity.application?.registerActivityLifecycleCallbacks(lifecycleCallbacks)
    }

    override fun getView(): View {
        Log.d("SudGamePlusPlugin","view = $view");
        GameManager.get().gameContainer = view
        return view
    }

    override fun dispose() {
        activity.application?.registerActivityLifecycleCallbacks(lifecycleCallbacks)
    }

}