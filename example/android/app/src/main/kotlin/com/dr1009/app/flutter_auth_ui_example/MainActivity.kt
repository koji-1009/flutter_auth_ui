package com.dr1009.app.flutter_auth_ui_example

import android.content.Intent
import android.os.Bundle
import com.dr1009.app.flutter_auth_ui.FlutterAuthUiPlugin
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // check intent
        FlutterAuthUiPlugin.catchEmailLink(this, intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        // check intent
        FlutterAuthUiPlugin.catchEmailLink(this, intent)
    }
}
