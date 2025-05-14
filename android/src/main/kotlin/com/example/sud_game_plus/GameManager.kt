package com.example.sud_game_plus

import android.util.Log
import android.widget.FrameLayout
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import tech.sud.mgp.core.ISudFSMMG
import tech.sud.mgp.core.ISudFSMStateHandle
import tech.sud.mgp.core.ISudFSTAPP
import tech.sud.mgp.core.ISudListenerNotifyStateChange
import tech.sud.mgp.core.SudLoadMGParamModel
import tech.sud.mgp.core.SudMGP

class GameManager {
    companion object{
        private var instance:GameManager?=null
        @Synchronized
        fun get():GameManager{
            if(null==instance) instance=GameManager()
            return instance as GameManager
        }
    }
    public var gameContainer: FrameLayout? = null
    private var _gameApp: ISudFSTAPP? = null // game interface

    fun playMG(){
        _gameApp?.playMG()
    }
    fun pauseMG(){
        _gameApp?.pauseMG()
    }
    fun  destroyMG(){
        _gameApp?.destroyMG()
        _gameApp = null
    }

    fun updateCode( code:String?,var2: ISudListenerNotifyStateChange?) {
        _gameApp?.updateCode(code ?: "", var2)
    }

    fun notifyStateChange( state:String,dataJson:String,var3:ISudListenerNotifyStateChange?) {
        _gameApp?.notifyStateChange(state, dataJson, var3)
    }

    fun loadGame(model: SudLoadMGParamModel,fsmMG:ISudFSMMG): ISudFSTAPP{

        _gameApp = SudMGP.loadMG(model,fsmMG)
        return  _gameApp!!

    }


}


