import Flutter
import UIKit
import FirebaseUI

public class SwiftFlutterAuthUiPlugin: NSObject, FlutterPlugin, FUIAuthDelegate {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_auth_ui", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterAuthUiPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        result?(user != nil)
        result = nil
    }
    
    private var result: FlutterResult? = nil
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = call.method
        if (method != "startUi") {
            result(FlutterMethodNotImplemented)
            return
        }
        
        guard let args = call.arguments as? [String: Any] else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        let setProvidersList = args["providers"] as? String
        let setProviders = setProvidersList?.split(separator: ",") ?? []
        var providers: [FUIAuthProvider] = []
        
        guard let authUI = FUIAuth.defaultAuthUI() else {
            result(false)
            return
        }
        setProviders.forEach { (e) in
            switch e {
            case "Anonymous":
                result(FlutterMethodNotImplemented)
            case "Email" :
                if let url = Bundle.main.object(forInfoDictionaryKey: "FirebaseAuthUiEmailHandleURL") as? String, !url.isEmpty {
                    // the email-link sign-in method.
                    let actionCodeSettings = ActionCodeSettings()
                    
                    actionCodeSettings.url = URL(string: url)
                    actionCodeSettings.handleCodeInApp = true
                    
                    if let packageName = Bundle.main.object(forInfoDictionaryKey: "FirebaseAuthUiEmailAndroidPackageName") as? String, !packageName.isEmpty,
                        let minimumVersion = Bundle.main.object(forInfoDictionaryKey: "FirebaseAuthUiEmailAndroidMinimumVersion") as? String, !minimumVersion.isEmpty {
                        actionCodeSettings.setAndroidPackageName(packageName, installIfNotAvailable: false, minimumVersion: minimumVersion)
                    }
                    
                    providers.append(FUIEmailAuth(authAuthUI: FUIAuth.defaultAuthUI()!, signInMethod: EmailLinkAuthSignInMethod, forceSameDevice: false, allowNewEmailAccounts: true, actionCodeSetting: actionCodeSettings))
                } else {
                    // the email & password sign-in method.
                    providers.append(FUIEmailAuth())
                }
            case "Phone" :
                providers.append(FUIPhoneAuth(authUI: FUIAuth.defaultAuthUI()!))
            case "Apple" :
                if #available(iOS 13.0, *) {
                    providers.append(FUIOAuth.appleAuthProvider())
                }
            case "Github" :
                providers.append(FUIOAuth.githubAuthProvider())
            case "Microsoft" :
                providers.append(FUIOAuth.microsoftAuthProvider())
            case "Yahoo" :
                providers.append(FUIOAuth.yahooAuthProvider())
            case "Google" :
                providers.append(FUIGoogleAuth.init(authUI: authUI))
            case "Facebook" :
                providers.append(FUIFacebookAuth.init(authUI: authUI))
            case "Twitter" :
                providers.append(FUIOAuth.twitterAuthProvider())
            default :
                result(FlutterMethodNotImplemented) // to avoid empty else branch, this branch is unused
            }
        }
        
        self.result = result
        
        authUI.delegate = self
        authUI.providers = providers
        
        if let tos = args["tosUrl"] as? String, let tosurl = URL(string: tos), let privacyPolicy = args["privacyPolicyUrl"] as? String, let privacyPolicyUrl = URL(string: privacyPolicy) {
            authUI.tosurl = tosurl
            authUI.privacyPolicyURL = privacyPolicyUrl
        }
        
        let authViewController = authUI.authViewController()
        let viewController = UIApplication.shared.delegate?.window??.rootViewController
        viewController?.present(authViewController, animated: true, completion: nil)
    }
}
