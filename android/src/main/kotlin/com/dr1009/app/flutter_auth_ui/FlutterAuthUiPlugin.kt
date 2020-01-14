package com.dr1009.app.flutter_auth_ui

import android.app.Activity
import android.app.Activity.RESULT_OK
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import com.firebase.ui.auth.AuthUI
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.auth.UserInfo
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
                instance.result?.success(mapFromUser(user))
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
        val lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding)

        lifecycle?.addObserver(object : LifecycleObserver {

            @OnLifecycleEvent(value = Lifecycle.Event.ON_CREATE)
            fun setUp() {
                binding.addActivityResultListener(instance.listener)
            }

            @OnLifecycleEvent(value = Lifecycle.Event.ON_DESTROY)
            fun tearDown() {
                binding.removeActivityResultListener(instance.listener)
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

    private val providers = mutableListOf<AuthUI.IdpConfig>()
    private var tosUrl: String? = null
    private var privacyPolicyUrl: String? = null

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "startUi" -> {
                val builder = AuthUI.getInstance()
                    .createSignInIntentBuilder()
                    .setAvailableProviders(providers)

                if (tosUrl != null && privacyPolicyUrl != null) {
                    builder.setTosAndPrivacyPolicyUrls(tosUrl!!, privacyPolicyUrl!!)
                }

                val intent = builder.build()
                instance.activity?.startActivityForResult(intent, RC_SIGN_IN)

                instance.result = result
            }
            "setAnonymous" -> {
                providers.add(AuthUI.IdpConfig.AnonymousBuilder().build())
                result.success(true)
            }
            "setEmail" -> {
                providers.add(AuthUI.IdpConfig.EmailBuilder().build())
                result.success(true)
            }
            "setPhone" -> {
                providers.add(AuthUI.IdpConfig.PhoneBuilder().build())
                result.success(true)
            }
            "setApple" -> {
                providers.add(AuthUI.IdpConfig.AppleBuilder().build())
                result.success(true)
            }
            "setGithub" -> {
                providers.add(AuthUI.IdpConfig.GitHubBuilder().build())
                result.success(true)
            }
            "setMicrosoft" -> {
                providers.add(AuthUI.IdpConfig.MicrosoftBuilder().build())
                result.success(true)
            }
            "setYahoo" -> {
                providers.add(AuthUI.IdpConfig.YahooBuilder().build())
                result.success(true)
            }
            "setGoogle" -> {
                providers.add(AuthUI.IdpConfig.GoogleBuilder().build())
                result.success(true)
            }
            "setFacebook" -> {
                providers.add(AuthUI.IdpConfig.FacebookBuilder().build())
                result.success(true)
            }
            "setTwitter" -> {
                providers.add(AuthUI.IdpConfig.TwitterBuilder().build())
                result.success(true)
            }
            "setTosAndPrivacyPolicy" -> {
                tosUrl = call.argument("tosUrl")
                privacyPolicyUrl = call.argument("privacyPolicyUrl")
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun mapFromUser(user: FirebaseUser?): Map<String, Any>? {
        if (user == null) {
            return null
        }

        val userMap = userInfoToMap(user).toMutableMap()
        val metadata = user.metadata
        if (metadata != null) {
            userMap["creationTimestamp"] = metadata.creationTimestamp
            userMap["lastSignInTimestamp"] = metadata.lastSignInTimestamp
        }
        userMap["isAnonymous"] = user.isAnonymous
        userMap["isEmailVerified"] = user.isEmailVerified

        val providerData = user.providerData.map { userInfoToMap(it) }
        userMap["providerData"] = providerData

        return userMap
    }

    private fun userInfoToMap(userInfo: UserInfo): Map<String, Any> {
        val map = mutableMapOf<String, Any>(
            "providerId" to userInfo.providerId,
            "uid" to userInfo.uid
        )

        if (userInfo.displayName != null) {
            map["displayName"] = userInfo.displayName ?: ""
        }
        if (userInfo.photoUrl != null) {
            map["photoUrl"] = userInfo.photoUrl.toString()
        }
        if (userInfo.email != null) {
            map["email"] = userInfo.email ?: ""
        }
        if (userInfo.phoneNumber != null) {
            map["phoneNumber"] = userInfo.phoneNumber ?: ""
        }

        return map.toMap()
    }
}
