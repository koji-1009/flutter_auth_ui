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
        if (user != nil) {
            // TODO
            result?.self(nil)
        } else {
            result?.self(error?.localizedDescription)
        }
        
        result = nil
    }
    
    private var providers: [FUIAuthProvider] = []
    private var result: FlutterResult? = nil
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
            break
        case "startUi":
            self.result = result
            
            guard let authUI = FUIAuth.defaultAuthUI() else {
                result(false)
                break
            }

            authUI.delegate = self
            authUI.providers = providers
            
            let authViewController = authUI.authViewController()
            let viewController = UIApplication.shared.delegate?.window??.rootViewController
            viewController?.present(authViewController, animated: true, completion: {})
            
            break
        case "setAnonymous":
            result(FlutterMethodNotImplemented)
            break
        case "setEmail":
            // TODO
            let actionCodeSettings = ActionCodeSettings()
            actionCodeSettings.url = URL(string: "https://example.appspot.com")
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setAndroidPackageName("com.firebase.example", installIfNotAvailable: false, minimumVersion: "12")

            let provider = FUIEmailAuth.init(authAuthUI: FUIAuth.defaultAuthUI()!, signInMethod: EmailLinkAuthSignInMethod, forceSameDevice: false, allowNewEmailAccounts: true, actionCodeSetting: actionCodeSettings)
            providers.append(provider)
            result(true)
            break
        case "setPhone":
            providers.append(FUIPhoneAuth(authUI: FUIAuth.defaultAuthUI()!))
            result(true)
            break
        case "setApple":
            if #available(iOS 13.0, *) {
                providers.append(FUIOAuth.appleAuthProvider())
                result(true)
            } else {
                result(false)
            }
            break
        case "setGithub":
            providers.append(FUIOAuth.githubAuthProvider())
            result(true)
            break
        case "setMicrosoft":
            providers.append(FUIOAuth.microsoftAuthProvider())
            result(true)
            break
        case "setYahoo":
            providers.append(FUIOAuth.yahooAuthProvider())
            result(true)
            break
        case "setFacebook":
            providers.append(FUIFacebookAuth())
            result(true)
            break
        case "setGoogle":
            providers.append(FUIGoogleAuth())
            result(true)
            break
        case "setTwitter":
            providers.append(FUIOAuth.twitterAuthProvider())
            result(true)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}
