import Flutter
import UIKit
import SudMGP

public class SudGamePlusPlugin: NSObject, FlutterPlugin,FlutterStreamHandler, FlutterPlatformViewFactory ,FlutterPlatformView, ISudFSMMG{

    
    private var platformView:UIView? = nil
    
    private var methodChannel:FlutterMethodChannel?
    
    private var eventChannel:FlutterEventChannel?
    
    private var pluginEventSink:FlutterEventSink?
    private var viewSize:String?
    private var gameConfig:String?
    private var gameApp:ISudFSTAPP?


    
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SudGamePlusPlugin()
    let channel = FlutterMethodChannel(name: "sud_game_plus", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: channel)
      instance.methodChannel = channel
    let eventChannel = FlutterEventChannel(name: "sud_game_event", binaryMessenger: registrar.messenger())
      eventChannel.setStreamHandler(instance)
      instance.eventChannel = eventChannel
      registrar.register(instance, withId: "SudMGPPluginView")
      
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getVersion":
        result(["version": SudMGP.getVersion(),"errorCode":0])
        break
    case "initSDK":
        
        let appid = (call.arguments as? [String:Any])?["appid"] as? String
        let appkey = (call.arguments as? [String:Any])?["appkey"] as? String
        let isTestEnv = (call.arguments as? [String:Any])?["isTestEnv"] as? Bool
        
        let model = SudInitSDKParamModel()
        model?.appId = appid
        model?.appKey = appkey;
        model?.isTestEnv = isTestEnv ?? false;
        SudMGP.initSDK(model!) { code, message in
            result(["message": message,"errorCode":code])
        }
        break
    case "getGameList":
        SudMGP.getMGList { errorCode, message, dataJson in
            result(["errorCode": errorCode,"dataJson":dataJson ?? "","message":message])
        }
        break
    case "loadGame":
        
        let userId = (call.arguments as? [String:Any])?["userid"] as? String
        let roomId = (call.arguments as? [String:Any])?["roomid"] as? String
        let code = (call.arguments as? [String:Any])?["code"] as? String
        let gameId = (call.arguments as? [String:Any])?["gameid"] as? Int
        let language = (call.arguments as? [String:Any])?["language"] as? String
        self.viewSize = (call.arguments as? [String:Any])?["viewSize"] as? String
        self.gameConfig = (call.arguments as? [String:Any])?["gameConfig"] as? String
        
        result(["message": "success","errorCode": 0])
                
        let model = SudLoadMGParamModel()
        model?.userId = userId
        model?.roomId = roomId;
        model?.code = code
        model?.mgId = gameId!;
        model?.language = language
        model?.gameViewContainer = self.platformView
        self.gameApp = SudMGP.loadMG(model!, fsmMG: self)
        
        break
    case "destroyGame":
        self.gameApp?.destroyMG()
        result(["message":"success","errorCode":0]);
        break
    case "updateCode":
        let code = (call.arguments as? [String:Any])?["code"] as? String
        self.gameApp?.updateCode(code!, listener: { code, message, dataJson in
            result(["message":message,"errorCode":code,"dataJson":dataJson]);
        })
        result(["message":"success","errorCode":0]);
        break
    case "notifyStateChange":
        let state = (call.arguments as? [String:Any])?["state"] as? String
        let dataJson = (call.arguments as? [String:Any])?["dataJson"] as? String
        self.gameApp?.notifyStateChange(state!, dataJson: dataJson!, listener: { retCode, retMsg, dataJson in
            result(["message":retMsg,"errorCode":retCode,"dataJson":dataJson]);
        })
        result(["message":"success","errorCode":0]);
        break
        
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    // MARK: - FlutterPlatformViewFactory
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> any FlutterPlatformView {
        platformView = UIView.init(frame: frame)
        return self
    }
    // MARK: - FlutterPlatformView
    public func view() -> UIView {
        return platformView ?? UIView()
    }
    
    // MARK: - FlutterStreamHandler
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.pluginEventSink = nil
        return nil
    }
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.pluginEventSink = events
        return nil
    }
    
    
// MARK: - ISudFSMMG
    
    public func onGameLog(_ dataJson: String) {
        DispatchQueue.main.async {
            self.pluginEventSink?(["method":"onGameLog","dataJson":dataJson])
        }
    }
    
    public func onGameLoadingProgress(_ stage: Int32, retCode: Int32, progress: Int32) {
        
    }
    
    public func onGameStarted() {
        DispatchQueue.main.async {
            self.pluginEventSink?(["method":"onGameStarted"])
        }
    }
    
    public func onGameDestroyed() {
        DispatchQueue.main.async {
            self.pluginEventSink?(["method":"onGameDestroyed"])
        }
    }
    
    public func onExpireCode(_ handle: any ISudFSMStateHandle, dataJson: String) {
        DispatchQueue.main.async {
            self.pluginEventSink?(["method":"onExpireCode","dataJson":dataJson])
        }
    }
    
    public func onGetGameViewInfo(_ handle: any ISudFSMStateHandle, dataJson: String) {
        DispatchQueue.main.async {
            self.pluginEventSink?(["method":"onGetGameViewInfo","dataJson":dataJson])
        }
        handle.success(self.viewSize!)
    }
    
    public func onGetGameCfg(_ handle: any ISudFSMStateHandle, dataJson: String) {
        handle.success(self.gameConfig!)
    }
    
    public func onGameStateChange(_ handle: any ISudFSMStateHandle, state: String, dataJson: String) {
        DispatchQueue.main.async {
            self.pluginEventSink?(["method":"onGameStateChange","state":state,"dataJson":dataJson])
        }
        handle.success("{}")
    }
    
    public func onPlayerStateChange(_ handle: (any ISudFSMStateHandle)?, userId: String, state: String, dataJson: String) {
        DispatchQueue.main.async {
            self.pluginEventSink?(["method":"onPlayerStateChange","userId":userId,"state":state,"dataJson":dataJson])
        }
        handle?.success("{}")
    }
    
}
