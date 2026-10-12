package com.gmate.g_mate

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var temiBridge: TemiBridge? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        temiBridge = TemiBridge(flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        temiBridge?.dispose()
        temiBridge = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
