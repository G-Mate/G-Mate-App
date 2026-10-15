package com.gmate.g_mate

import android.os.Handler
import android.os.Looper
import com.robotemi.sdk.Robot
import com.robotemi.sdk.SttLanguage
import com.robotemi.sdk.TtsRequest
import com.robotemi.sdk.listeners.OnConversationStatusChangedListener
import com.robotemi.sdk.listeners.OnGoToLocationStatusChangedListener
import com.robotemi.sdk.listeners.OnLocationsUpdatedListener
import com.robotemi.sdk.listeners.OnRobotReadyListener
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Flutter 플랫폼 채널과 temi SDK를 잇는 브리지.
 *
 * Dart 명령(`gmate/robot`)은 [Robot] 호출로 바꾸고, temi 리스너 콜백은
 * `{"type": ...}` Map으로 바꿔 `gmate/robot/events`로 보낸다.
 * temi가 아닌 기기(에뮬레이터)에서는 `onRobotReady`가 오지 않으므로
 * [isReady]가 false로 남고, 명령은 `NOT_READY` 오류로 답한다.
 */
class TemiBridge(messenger: BinaryMessenger) :
    MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler,
    OnRobotReadyListener,
    OnGoToLocationStatusChangedListener,
    OnLocationsUpdatedListener,
    OnConversationStatusChangedListener,
    Robot.AsrListener,
    Robot.TtsListener {

    private val methodChannel = MethodChannel(messenger, RobotChannels.METHOD)
    private val eventChannel = EventChannel(messenger, RobotChannels.EVENTS)
    private val mainHandler = Handler(Looper.getMainLooper())
    private val robot: Robot = Robot.getInstance()
    private var eventSink: EventChannel.EventSink? = null

    /** `onRobotReady(true)`를 받았는지. false면 temi SDK를 부르지 않는다. */
    private var isReady = false

    init {
        methodChannel.setMethodCallHandler(this)
        eventChannel.setStreamHandler(this)
    }

    /** 화면이 보일 때(Activity onStart) temi 리스너를 붙인다. */
    fun attach() {
        robot.addOnRobotReadyListener(this)
        robot.addOnGoToLocationStatusChangedListener(this)
        robot.addOnLocationsUpdatedListener(this)
        robot.addTtsListener(this)
        robot.addAsrListener(this)
        robot.addOnConversationStatusChangedListener(this)
    }

    /** 화면이 가려질 때(Activity onStop) temi 리스너를 뗀다. */
    fun detach() {
        robot.removeOnRobotReadyListener(this)
        robot.removeOnGoToLocationStatusChangedListener(this)
        robot.removeOnLocationsUpdateListener(this)
        robot.removeTtsListener(this)
        robot.removeAsrListener(this)
        robot.removeOnConversationStatusChangedListener(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "isReady") {
            result.success(isReady)
            return
        }
        if (!isReady) {
            result.error(NOT_READY, "temi가 준비되지 않았습니다 (onRobotReady 전)", null)
            return
        }
        when (call.method) {
            "getLocations" -> result.success(robot.locations)
            "saveLocation" -> result.success(robot.saveLocation(call.requireKey()))
            "deleteLocation" -> result.success(robot.deleteLocation(call.requireKey()))
            "goTo" -> {
                robot.goTo(call.requireKey())
                result.success(null)
            }
            "stopMovement" -> {
                robot.stopMovement()
                result.success(null)
            }
            "speak" -> {
                val text = call.argument<String>("text")
                if (text == null) {
                    result.error(BAD_ARGUMENT, "text가 없습니다", null)
                    return
                }
                robot.speak(TtsRequest.create(text, false))
                result.success(null)
            }
            "cancelAllTtsRequests" -> {
                robot.cancelAllTtsRequests()
                result.success(null)
            }
            "askQuestion" -> {
                val text = call.argument<String>("text")
                if (text == null) {
                    result.error(BAD_ARGUMENT, "text가 없습니다", null)
                    return
                }
                robot.askQuestion(text)
                result.success(null)
            }
            "finishConversation" -> {
                robot.finishConversation()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        // 늦게 구독해도 지금 준비 상태를 알 수 있게 한 번 보낸다.
        emit(mapOf("type" to "robotReady", "isReady" to isReady))
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onRobotReady(isReady: Boolean) {
        this.isReady = isReady
        emit(mapOf("type" to "robotReady", "isReady" to isReady))
    }

    override fun onGoToLocationStatusChanged(
        location: String,
        status: String,
        descriptionId: Int,
        description: String,
    ) {
        // temi 상태 문자열(start, calculating, going, complete, abort, reposing)은
        // Dart GoToStatus 이름과 같다.
        emit(
            mapOf(
                "type" to "goToStatus",
                "location" to location,
                "status" to status,
                "descriptionId" to descriptionId,
            ),
        )
    }

    override fun onLocationsUpdated(locations: List<String>) {
        emit(mapOf("type" to "locationsUpdated", "locations" to locations))
    }

    override fun onTtsStatusChanged(ttsRequest: TtsRequest) {
        val status = when (ttsRequest.status) {
            TtsRequest.Status.STARTED -> "started"
            TtsRequest.Status.COMPLETED -> "completed"
            TtsRequest.Status.ERROR, TtsRequest.Status.NOT_ALLOWED -> "error"
            TtsRequest.Status.CANCELED -> "cancelled"
            else -> return // PENDING, PROCESSING은 Dart에 알리지 않는다.
        }
        emit(mapOf("type" to "ttsStatus", "text" to ttsRequest.speech, "status" to status))
    }

    override fun onAsrResult(asrResult: String, sttLanguage: SttLanguage) {
        // 앱이 말을 직접 처리하므로(OVERRIDE_NLU) temi 기본 대화가 이어지지 않게 끝낸다.
        robot.finishConversation()
        emit(mapOf("type" to "asrResult", "text" to asrResult))
    }

    override fun onConversationStatusChanged(status: Int, text: String) {
        val name = when (status) {
            OnConversationStatusChangedListener.IDLE -> "idle"
            OnConversationStatusChangedListener.LISTENING -> "listening"
            OnConversationStatusChangedListener.THINKING -> "thinking"
            OnConversationStatusChangedListener.SPEAKING -> "speaking"
            else -> return
        }
        emit(mapOf("type" to "conversationStatus", "status" to name))
    }

    /** `{"type": ...}` 형태의 이벤트를 Dart로 보낸다. temi 콜백 스레드와 상관없이 메인 스레드에서 보낸다. */
    private fun emit(event: Map<String, Any?>) {
        mainHandler.post { eventSink?.success(event) }
    }

    private fun MethodCall.requireKey(): String =
        argument<String>("key") ?: throw IllegalArgumentException("key가 없습니다")

    fun dispose() {
        detach()
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        eventSink = null
    }

    private companion object {
        const val NOT_READY = "NOT_READY"
        const val BAD_ARGUMENT = "BAD_ARGUMENT"
    }
}
