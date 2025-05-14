package com.example.sud_game_plus

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import tech.sud.mgp.core.ISudFSMMG
import tech.sud.mgp.core.ISudFSMStateHandle
import tech.sud.mgp.core.ISudListenerGetMGList
import tech.sud.mgp.core.ISudListenerInitSDK
import tech.sud.mgp.core.SudInitSDKParamModel
import tech.sud.mgp.core.SudLoadMGParamModel
import tech.sud.mgp.core.SudMGP

/** SudGamePlusPlugin */
class SudGamePlusPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware{

  private  val TAG: String = "SudGamePlusPlugin"
  private lateinit var channel : MethodChannel
  private lateinit var eventChannel: EventChannel
  private var eventSink: EventChannel.EventSink? = null
//
  private var uiHandler: Handler? = null
  private var context: Context? = null
  private var activity: Activity? = null


//
  private var _gameView: View? = null

  private var _viewSize: String? = null
  private var _gameConfig: String? = null

  private lateinit var _flutterPluginBinding: FlutterPlugin.FlutterPluginBinding



  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(TAG,"onAttachedToEngine  flutterPluginBinding:$flutterPluginBinding")
    _flutterPluginBinding = flutterPluginBinding
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sud_game_plus")
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "sud_game_event")
    channel.setMethodCallHandler(this)
    eventChannel.setStreamHandler(this)
    context = flutterPluginBinding.applicationContext
    if (uiHandler == null) {
      uiHandler = Handler(Looper.getMainLooper())
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(TAG,"onDetachedFromEngine")
    channel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    Log.d(TAG,"onMethodCall call = ${call.method} arg = ${call.arguments}")
    when (call.method) {
      "getVersion" -> {
        getVersion(call, result)
      }

      "initSDK" -> {
        initSDK(call, result)
      }

      "loadGame" -> {
        loadGame(call, result)
      }

      "pauseMG" -> {
        pauseMG(call, result)
      }

      "playMG" -> {
        playMG(call, result)
      }

      "destroyGame" -> {
        destroyGame(call, result)
      }

      "getGameList" -> {
        getGameList(call, result)
      }

      "updateCode" -> {
        updateCode(call, result)
      }

      "notifyStateChange" -> {
        notifyStateChange(call, result)
      }

      else -> {
        result.notImplemented()
      }
    }

  }


  override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
    Log.d(TAG,"onListen call = $arguments arg = $events")
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    Log.d(TAG,"onCancel call = $arguments")
    eventSink = null
  }

  override fun onAttachedToActivity(p0: ActivityPluginBinding) {
    Log.d(TAG,"onAttachedToActivity ActivityPluginBinding = $p0")
    activity = p0.activity
    Log.d(TAG, "onAttachedToActivity kt sud activity:$activity")
    _flutterPluginBinding.platformViewRegistry.registerViewFactory("SudMGPPluginView",NativeViewFactory(activity!!))

  }

  override fun onDetachedFromActivity() {
    Log.d(TAG, "onDetachedFromActivity")
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    Log.d(TAG, "onReattachedToActivityForConfigChanges binding = $binding")
    activity = binding.activity

    _flutterPluginBinding.platformViewRegistry.registerViewFactory("SudMGPPluginView",NativeViewFactory(activity!!))
  }

  override fun onDetachedFromActivityForConfigChanges() {
    Log.d(TAG, "onDetachedFromActivityForConfigChanges")
    activity = null
  }


  /****************响应回调方法****************/

  private fun getVersion(call: MethodCall, result: MethodChannel.Result) {
    Log.d(TAG, "getVersion invoked")
    var version = SudMGP.getVersion();
    result.success(mapOf("errorCode" to 0, "version" to version))
  }

  private fun initSDK(call: MethodCall, result: MethodChannel.Result) {
    Log.d(TAG, "initSDK invoked")
    val appid: String? = call.argument<String>("appid")
    val appkey: String? = call.argument<String>("appkey")
    var isTestEnv: Boolean? = call.argument<Boolean>("isTestEnv")

//    SudInitSDKParamModel model, ISudListenerInitSDK listener
    val model = SudInitSDKParamModel()
    model.context = context
    model.appId = appid
    model.appKey = appkey
    model.isTestEnv = isTestEnv ?: false
    val listener = object : ISudListenerInitSDK {
      override fun onSuccess() {
        Log.d(TAG, "initSDK success")
        result.success(mapOf("errorCode" to 0, "message" to "success"))
      }

      override fun onFailure(p0: Int, p1: String?) {
        Log.d(TAG, "initSDK onFailure errorCode = $p0 message = $p1")
        result.success(mapOf("errorCode" to p0, "message" to p1))
      }

    }
    SudMGP.initSDK(model,listener)

  }

  private fun getGameList(call: MethodCall, result: MethodChannel.Result) {
    Log.d(TAG, "getGameList invoked")
    SudMGP.getMGList(object : ISudListenerGetMGList {
      override fun onSuccess(dataJson: String?) {
        Log.d(TAG, "getGameList onSuccess dataJson = $dataJson")
        result.success(mapOf("errorCode" to 0, "message" to "success", "dataJson" to dataJson))
      }

      override fun onFailure(errorCode: Int, message: String) {
        Log.d(TAG, "getGameList onFailure errorCode = $errorCode ,message = $message")
        result.success(mapOf("errorCode" to errorCode, "message" to message))
      }
    })
  }

  private fun destroyGame(call: MethodCall, result: MethodChannel.Result) {
    Log.d(TAG, "destroyGame invoked")
    GameManager.get().destroyMG()
    GameManager.get().gameContainer?.removeAllViews()
    result.success(mapOf("errorCode" to 0, "message" to "success"))
  }

  private fun updateCode(call: MethodCall, result: MethodChannel.Result) {
    Log.d(TAG, "updateCode invoked")
    val code: String? = call.argument<String>("code")
    GameManager.get().updateCode(code ?: "", null)
    result.success(mapOf("errorCode" to 0, "message" to "success"))
  }

  private fun notifyStateChange(call: MethodCall, result: MethodChannel.Result) {
    Log.d(TAG, "notifyStateChange invoked")
    val state: String = call.argument<String>("state") ?: ""
    val dataJson: String = call.argument<String>("dataJson") ?: ""
    GameManager.get().notifyStateChange(state, dataJson, null)
    result.success(mapOf("errorCode" to 0, "message" to "success"))
  }

  private fun loadGame(call: MethodCall, result: MethodChannel.Result) {
    Log.d(TAG, "loadGame invoked")
    val userid: String? = call.argument<String>("userid")
    val roomid: String? = call.argument<String>("roomid")
    val code: String? = call.argument<String>("code")
    var gameid: Long? = call.argument<Long>("gameid")
    val language: String? = call.argument<String>("language")
    _viewSize = call.argument<String>("viewSize")
    _gameConfig = call.argument<String>("gameConfig")
    val model = SudLoadMGParamModel()
    model.userId = userid
    model.roomId = roomid
    model.code = code
    model.language = language
    model.mgId = gameid ?: 0
    model.activity = activity
    val sud = object: ISudFSMMG{
      override fun onGameLog(p0: String?) {
        uiHandler?.post(Runnable { eventSink?.success(mapOf("method" to "onGameLog", "dataJson" to p0)) })
      }

      override fun onGameLoadingProgress(p0: Int, p1: Int, p2: Int) {
        Log.d(TAG, "onGameLoadingProgress p0= $p0 p1= $p1 p2=$p2")
      }

      override fun onGameStarted() {
        Log.d(TAG, "onGameStarted")
        uiHandler?.post(Runnable { eventSink?.success(mapOf("method" to "onGameStarted")) })
      }

      override fun onGameDestroyed() {
        Log.d(TAG, "onGameDestroyed")
        uiHandler?.post(Runnable { eventSink?.success(mapOf("method" to "onGameDestroyed")) })
      }

      override fun onExpireCode(p0: ISudFSMStateHandle?, p1: String?) {
        Log.d(TAG, "onGameDestroyed")
        uiHandler?.post(Runnable { eventSink?.success(mapOf("method" to "onExpireCode", "dataJson" to p1)) })
        p0?.success("{}");
      }

      override fun onGetGameViewInfo(p0: ISudFSMStateHandle?, p1: String?) {
        Log.d(TAG, "onGetGameViewInfo")
        p0?.success(_viewSize);
      }

      override fun onGetGameCfg(p0: ISudFSMStateHandle?, p1: String?) {
        Log.d(TAG, "onGetGameCfg dataJson = $p1")
        p0?.success(_gameConfig);
      }

      override fun onGameStateChange(p0: ISudFSMStateHandle?, p1: String?, p2: String?) {
        Log.d(TAG, "onGameStateChange state = $p1 dataJson = $p2")
        uiHandler?.post(Runnable { eventSink?.success(mapOf("method" to "onGameStateChange", "dataJson" to p2, "state" to p1)) })
        p0?.success("{}");
      }

      override fun onPlayerStateChange(handle: ISudFSMStateHandle?, userId: String, state: String, dataJson: String) {
        Log.d(TAG, "onPlayerStateChange userId = $userId state = $state dataJson = $dataJson")
        uiHandler?.post(Runnable {
          eventSink?.success(
            mapOf(
              "method" to "onPlayerStateChange",
              "dataJson" to dataJson,
              "userId" to userId,
              "state" to state
            )
          )
        })
        handle?.success("{}");
      }
    }
   val game = GameManager.get().loadGame(model,sud)
    _gameView = game.gameView
    _gameView?.let {
      GameManager.get().gameContainer!!.addView(it, FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT)
    }
    Log.d("sud", "kt sud gameView:$_gameView")
    result.success(mapOf("errorCode" to 0, "message" to "success"))
  }

  private fun pauseMG(call: MethodCall, result: MethodChannel.Result) {
    Log.d(TAG, "pauseMG invoked")
    GameManager.get().pauseMG()
    result.success(mapOf("errorCode" to 0, "message" to "success"))
  }

  private fun playMG(call: MethodCall, result: MethodChannel.Result) {
    Log.d(TAG, "playMG invoked")
    GameManager.get().playMG()
    result.success(mapOf("errorCode" to 0, "message" to "success"))
  }




}
