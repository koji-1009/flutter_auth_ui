package com.dr1009.app.flutter_auth_ui

import android.app.Activity
import android.app.Activity.RESULT_OK
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.LifecycleOwner
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

        private const val RC_SIGN_IN = 123

        private val instance = FlutterAuthUiPlugin()

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_auth_ui")
            channel.setMethodCallHandler(instance)
        }
    }

    private var activity: Activity? = null
    private var result: Result? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_auth_ui")
        channel.setMethodCallHandler(instance)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // nop
    }

    private val listener = PluginRegistry.ActivityResultListener { requestCode, resultCode, _ ->
        if (requestCode == RC_SIGN_IN) {
            if (resultCode == RESULT_OK) {
                val user = FirebaseAuth.getInstance().currentUser
                instance.result?.success(user != null)
            } else {
                instance.result?.error(resultCode.toString(), "error result", null)
            }

            instance.result = null
            return@ActivityResultListener true
        }

        return@ActivityResultListener false
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        instance.activity = binding.activity
        FlutterLifecycleAdapter
            .getActivityLifecycle(binding)
            .addObserver(object : LifecycleEventObserver {
                override fun onStateChanged(source: LifecycleOwner, event: Lifecycle.Event) {
                    when (event) {
                        Lifecycle.Event.ON_CREATE -> {
                            binding.addActivityResultListener(instance.listener)
                        }
                        Lifecycle.Event.ON_DESTROY -> {
                            binding.removeActivityResultListener(instance.listener)
                        }
                        else -> {
                            // nop
                        }
                    }
                }
            })
    }

    override fun onDetachedFromActivity() {
        instance.activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        // nop
    }

    override fun onDetachedFromActivityForConfigChanges() {
        // nop
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        val method = call.method
        if (method != "startUi") {
            result.notImplemented()
            return
        }

        val setProviders = call.argument<String>("providers").orEmpty().split(",")
        val providers = setProviders.map { name ->
            when (name) {
                "Anonymous" -> AuthUI.IdpConfig.AnonymousBuilder().build()
                "Email" -> AuthUI.IdpConfig.EmailBuilder()
                    .setRequireName(call.argument<Boolean?>("requireNameForAndroid") ?: true)
                    .build()
                "Phone" -> AuthUI.IdpConfig.PhoneBuilder().build()
                "Apple" -> AuthUI.IdpConfig.AppleBuilder().build()
                "Github" -> AuthUI.IdpConfig.GitHubBuilder().build()
                "Microsoft" -> AuthUI.IdpConfig.MicrosoftBuilder().build()
                "Yahoo" -> AuthUI.IdpConfig.YahooBuilder().build()
                "Google" -> AuthUI.IdpConfig.GoogleBuilder().build()
                "Facebook" -> AuthUI.IdpConfig.FacebookBuilder().build()
                "Twitter" -> AuthUI.IdpConfig.TwitterBuilder().build()
                else -> {
                    result.notImplemented()
                    return
                }
            }
        }

        val enableSmartLockForAndroid = call.argument<Boolean>("enableSmartLockForAndroid")
        val builder = AuthUI.getInstance()
            .createSignInIntentBuilder()
            .setIsSmartLockEnabled(enableSmartLockForAndroid ?: true) // default is true
            .setAvailableProviders(providers)

        val tosUrl = call.argument<String?>("tosUrl")
        val privacyPolicyUrl = call.argument<String?>("privacyPolicyUrl")
        if (!tosUrl.isNullOrEmpty() && !privacyPolicyUrl.isNullOrEmpty()) {
            builder.setTosAndPrivacyPolicyUrls(tosUrl, privacyPolicyUrl)
        }

        val intent = builder.build()
        instance.activity?.startActivityForResult(intent, RC_SIGN_IN)

        instance.result = result
    }
}
