package com.dr1009.app.example;

import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.dr1009.app.flutter_auth_ui.FlutterAuthUiPlugin;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // check intent
        FlutterAuthUiPlugin.catchEmailLink(this, getIntent());
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);

        // check intent
        FlutterAuthUiPlugin.catchEmailLink(this, intent);
    }
}
