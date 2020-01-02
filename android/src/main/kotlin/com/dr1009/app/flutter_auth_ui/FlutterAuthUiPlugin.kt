package com.dr1009.app.flutter_auth_ui

import android.app.Activity
import android.app.Activity.RESULT_OK
import androidx.annotation.NonNull
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import com.firebase.ui.auth.AuthUI
import com.google.firebase.auth.FirebaseAuth
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar

/** FlutterAuthUiPlugin */
class FlutterAuthUiPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {

    companion object {

        @JvmStatic
        val instance = FlutterAuthUiPlugin()

        private const val RC_SIGN_IN = 123

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_auth_ui")
            channel.setMethodCallHandler(instance)
        }
    }

    private var activity: Activity? = null
    private var result: Result? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_auth_ui")
        channel.setMethodCallHandler(instance)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        // nop
    }

    private val listener = PluginRegistry.ActivityResultListener { requestCode, resultCode, data ->
        if (requestCode == RC_SIGN_IN) {
            if (resultCode == RESULT_OK && FirebaseAuth.getInstance().currentUser != null) {
                result?.success(null)
            } else {
                result?.error(resultCode.toString(), "error result", null)
            }

            result = null
            return@ActivityResultListener true
        }

        return@ActivityResultListener false
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        val lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding)

        lifecycle?.addObserver(object : LifecycleObserver {

            @OnLifecycleEvent(value = Lifecycle.Event.ON_CREATE)
            fun setUp() {
                binding.addActivityResultListener(listener)
            }

            @OnLifecycleEvent(value = Lifecycle.Event.ON_DESTROY)
            fun tearDown() {
                binding.removeActivityResultListener(listener)
            }
        })
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        // nop
    }

    override fun onDetachedFromActivityForConfigChanges() {
        // nop
    }

    private val providers = mutableListOf<AuthUI.IdpConfig>()

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "setEmail" -> {
                providers.add(AuthUI.IdpConfig.EmailBuilder().build())
            }
            "setPhone" -> {
                providers.add(AuthUI.IdpConfig.PhoneBuilder().build())
            }
            "setApple" -> {
                providers.add(AuthUI.IdpConfig.AppleBuilder().build())
            }
            "startUi" -> {
                val intent = AuthUI.getInstance()
                    .createSignInIntentBuilder()
                    .setAvailableProviders(providers)
                    .build()
                activity?.startActivityForResult(intent, RC_SIGN_IN)

                this.result = result
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
