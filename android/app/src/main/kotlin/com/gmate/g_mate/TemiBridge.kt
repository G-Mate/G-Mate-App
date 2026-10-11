package com.gmate.g_mate

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Flutter 플랫폼 채널과 temi SDK를 잇는 브리지.
 *
 * temi SDK 의존성을 추가하기 전까지는 채널만 열어 두고, 명령은 notImplemented로 응답한다.
 * SDK를 붙이면 각 명령을 Robot.getInstance() 호출로, 리스너 콜백을 [emit]으로 바꾼다.
 */
class TemiBridge(messenger: BinaryMessenger) :
    MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler {

    private val methodChannel = MethodChannel(messenger, RobotChannels.METHOD)
    private val eventChannel = EventChannel(messenger, RobotChannels.EVENTS)
    private var eventSink: EventChannel.EventSink? = null

    init {
        methodChannel.setMethodCallHandler(this)
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isReady" -> result.success(false)
            else -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    /** `{"type": ...}` 형태의 이벤트를 Dart로 보낸다. */
    fun emit(event: Map<String, Any?>) {
        eventSink?.success(event)
    }

    fun dispose() {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        eventSink = null
    }
}
