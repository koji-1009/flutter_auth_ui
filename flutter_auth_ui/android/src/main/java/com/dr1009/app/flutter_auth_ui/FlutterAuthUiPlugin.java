package com.dr1009.app.flutter_auth_ui;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleEventObserver;
import androidx.lifecycle.LifecycleOwner;

import com.firebase.ui.auth.AuthUI;
import com.google.firebase.auth.ActionCodeSettings;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

import java.util.ArrayList;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/**
 * FlutterAuthUiPlugin
 */
public class FlutterAuthUiPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

    private static final int RC_SIGN_IN = 123;

    @Nullable
    private MethodChannel methodChannel = null;
    @Nullable
    private Activity activity = null;
    @Nullable
    private Result result = null;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel = new MethodChannel(binding.getBinaryMessenger(), "flutter_auth_ui");
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        activity = null;
        result = null;

        if (methodChannel != null) {
            methodChannel.setMethodCallHandler(null);
            methodChannel = null;
        }
    }

    @NonNull
    private final PluginRegistry.ActivityResultListener listener =
            new PluginRegistry.ActivityResultListener() {
                @Override
                public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
                    if (requestCode != RC_SIGN_IN) {
                        return false;
                    }

                    if (result == null) {
                        // error
                        return true;
                    }

                    if (resultCode == Activity.RESULT_OK) {
                        FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();
                        result.success(user != null);
                    } else {
                        result.error(String.valueOf(resultCode), "error result", null);
                    }

                    result = null;
                    return true;
                }
            };

    @Override
    public void onAttachedToActivity(@NonNull final ActivityPluginBinding binding) {
        activity = binding.getActivity();
        FlutterLifecycleAdapter
                .getActivityLifecycle(binding)
                .addObserver(new LifecycleEventObserver() {
                    @Override
                    public void onStateChanged(@NonNull LifecycleOwner source, @NonNull Lifecycle.Event event) {
                        switch (event) {
                            case ON_CREATE:
                                binding.addActivityResultListener(listener);
                                break;
                            case ON_DESTROY:
                                binding.removeActivityResultListener(listener);
                                break;
                            default:
                                // nop
                        }
                    }
                });
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        String method = call.method;
        if (!"startUi".equals(method)) {
            result.notImplemented();
            return;
        }

        ArrayList<AuthUI.IdpConfig> providers = new ArrayList<>();
        String providerArray = call.argument("providers");
        if (providerArray != null && !providerArray.isEmpty()) {
            for (String name : providerArray.split(",")) {
                switch (name) {
                    case "Anonymous":
                        providers.add(new AuthUI.IdpConfig.AnonymousBuilder().build());
                        break;
                    case "Email":
                        AuthUI.IdpConfig.EmailBuilder builder = new AuthUI.IdpConfig.EmailBuilder();
                        Boolean requireDisplayName = call.argument("emailLinkRequireDisplayName");
                        if (requireDisplayName != null) {
                            builder.setRequireName(requireDisplayName);
                        }

                        Boolean enableEmailLink = call.argument("emailLinkEnableEmailLink");
                        if (enableEmailLink != null && enableEmailLink) {
                            builder.enableEmailLinkSignIn();

                            ActionCodeSettings.Builder actionCodeSettings = ActionCodeSettings
                                    .newBuilder()
                                    .setHandleCodeInApp(true);

                            String url = call.argument("emailLinkHandleURL");
                            if (url == null || url.isEmpty()) {
                                result.error(
                                        "InvalidArgs",
                                        "Missing handleURL",
                                        "Expected valid handleURL."
                                );
                                return;
                            }
                            actionCodeSettings.setUrl(url);

                            String packageName = call.argument("emailLinkAndroidPackageName");
                            String minimumVersion = call.argument("emailLinkAndroidMinimumVersion");
                            if (packageName != null && !packageName.isEmpty()) {
                                actionCodeSettings.setAndroidPackageName(packageName, false, minimumVersion);
                            }
                            builder.setActionCodeSettings(actionCodeSettings.build());
                        }

                        providers.add(builder.build());
                        break;
                    case "Phone":
                        providers.add(new AuthUI.IdpConfig.PhoneBuilder().build());
                        break;
                    case "Apple":
                        providers.add(new AuthUI.IdpConfig.AppleBuilder().build());
                        break;
                    case "Github":
                        providers.add(new AuthUI.IdpConfig.GitHubBuilder().build());
                        break;
                    case "Microsoft":
                        providers.add(new AuthUI.IdpConfig.MicrosoftBuilder().build());
                        break;
                    case "Yahoo":
                        providers.add(new AuthUI.IdpConfig.YahooBuilder().build());
                        break;
                    case "Google":
                        providers.add(new AuthUI.IdpConfig.GoogleBuilder().build());
                        break;
                    case "Facebook":
                        providers.add(new AuthUI.IdpConfig.FacebookBuilder().build());
                        break;
                    case "Twitter":
                        providers.add(new AuthUI.IdpConfig.TwitterBuilder().build());
                        break;
                    default:
                        result.notImplemented();
                        return;
                }
            }
        }

        AuthUI.SignInIntentBuilder builder = AuthUI
                .getInstance()
                .createSignInIntentBuilder()
                .setAvailableProviders(providers);

        // design
        boolean showLogoAndroid = call.argument("showLogoAndroid");
        if (showLogoAndroid) {
            builder.setLogo(R.drawable.flutter_auth_ui_logo);
        }
        boolean overrideThemeAndroid = call.argument("overrideThemeAndroid");
        if (overrideThemeAndroid) {
            builder.setTheme(R.style.flutter_auth_ui_style);
        }

        boolean autoUpgradeAnonymousUsers = call.argument("autoUpgradeAnonymousUsers");
        if (autoUpgradeAnonymousUsers) {
            builder.enableAnonymousUsersAutoUpgrade();
        }

        Boolean enableSmartLockForAndroid = call.argument("enableSmartLockForAndroid");
        if (enableSmartLockForAndroid != null) {
            builder.setIsSmartLockEnabled(enableSmartLockForAndroid);
        }

        String tosUrl = call.argument("tosUrl");
        String privacyPolicyUrl = call.argument("privacyPolicyUrl");
        if (tosUrl != null && !tosUrl.isEmpty() &&
                privacyPolicyUrl != null && !privacyPolicyUrl.isEmpty()) {
            builder.setTosAndPrivacyPolicyUrls(tosUrl, privacyPolicyUrl);
        }

        Intent intent = builder.build();
        if (activity != null) {
            activity.startActivityForResult(intent, RC_SIGN_IN);
        }

        this.result = result;
    }
}
