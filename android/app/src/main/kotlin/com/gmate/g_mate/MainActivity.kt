package com.gmate.g_mate

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var temiBridge: TemiBridge? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        temiBridge = TemiBridge(flutterEngine.dartExecutor.binaryMessenger)
    }

    // temi 예제처럼 화면이 보이는 동안만 리스너를 붙여 둔다.
    override fun onStart() {
        super.onStart()
        temiBridge?.attach()
    }

    override fun onStop() {
        temiBridge?.detach()
        super.onStop()
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        temiBridge?.dispose()
        temiBridge = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
