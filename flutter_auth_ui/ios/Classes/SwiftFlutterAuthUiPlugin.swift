import FirebaseAnonymousAuthUI
import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI
import FirebaseOAuthUI
import FirebasePhoneAuthUI
import Flutter
import UIKit

public class SwiftFlutterAuthUiPlugin: NSObject, FlutterPlugin, FUIAuthDelegate {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_auth_ui", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterAuthUiPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }

//  #############################################################
//  As the email is persisted and available between launches it's
//  possible to finish authentication process even if the user
//  closed the application before tapping the link.
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        if let activity = launchOptions[UIApplication.LaunchOptionsKey.userActivityDictionary] as? NSUserActivity {
            handleActivity(activity)
        }
       
        // Allow others to handle their part
        return false
    }
//  ##############################################################
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]) -> Void) -> Bool {
        return handleActivity(userActivity)
    }
    
// "2. Once you catch the deep link, you will need to pass it to the auth UI so it can be handled."
// See https:firebase.google.com/docs/auth/ios/firebaseui#email_link_authentication
   @discardableResult private func handleActivity(_ userActivity: NSUserActivity) -> Bool {
        guard
            let bundle = Bundle.main.bundleIdentifier,
            let authUI = FUIAuth.defaultAuthUI(),
            let link = link(from: userActivity) else {
            return false
        }
        
    
//    #######################################################################
//    If the deep link is being caught during the cold launch of the app
//    i.e. in application(_:, didFinishLaunchingWithOptions:)
//    there are no providers registered in AuthUI yet. However, the email
//    is persisted so we can finish authentication process if the persisted
//    email matches the link tapped. To do this we have to add FUIEmailAuth to
//    the providers list.
        if (authUI.providers.isEmpty) {
            authUI.providers = [FUIEmailAuth()]
        }
//    ########################################################################
    
        guard
            Auth.auth().isSignIn(withEmailLink: link.absoluteString),
            authUI.handleOpen(link, sourceApplication: bundle) else {
            return false
        }
    
        return true
    }

//  See https://firebase.google.com/docs/dynamic-links/create-manually#parameters
    private func link(from activity: NSUserActivity) -> URL? {
        guard
            activity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = activity.webpageURL,
            let components = NSURLComponents(string: url.absoluteString),
            let link = components.queryItems?.first(where: { $0.name == "link" })?.value,
            let url = URL(string: link) else {
            return nil
        }
        
        return url
    }

    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        result?(user != nil)
        result = nil
    }

    private var result: FlutterResult?

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = call.method
        if method != "startUi" {
            result(FlutterMethodNotImplemented)
            return
        }

        guard let args = call.arguments as? [String: Any] else {
            result(FlutterError(code: "InvalidArgs", message: "Missing arguments", details: "Expected valid arguments."))
            return
        }

        let setProvidersList = args["providers"] as? String
        let setProviders = setProvidersList?.split(separator: ",") ?? []
        var providers: [FUIAuthProvider] = []

        guard let authUI = FUIAuth.defaultAuthUI() else {
            result(false)
            return
        }
        authUI.shouldAutoUpgradeAnonymousUsers = args["autoUpgradeAnonymousUsers"] as? Bool ?? false

        setProviders.forEach { (e) in
            switch e {
            case "Anonymous":
                providers.append(FUIAnonymousAuth(authUI: authUI))
            case "Email" :
                let requireDisplayName = args["emailLinkRequireDisplayName"] as? Bool ?? true
                let actionCodeSettings = ActionCodeSettings()
                if args["emailLinkEnableEmailLink"] as? Bool ?? false {
                    // the email-link sign-in method.
                    let url = args["emailLinkHandleURL"] as? String ?? ""
                    guard !url.isEmpty else {
                        result(FlutterError(code: "invalidArgs", message: "Missing handleURL", details: "Expected valid handleURL."))
                        return
                    }
                    actionCodeSettings.url = URL(string: url)
                    actionCodeSettings.handleCodeInApp = true

                    let packageName = args["emailLinkAndroidPackageName"] as? String ?? ""
                    let minimumVersion = args["emailLinkAndroidMinimumVersion"] as? String ?? ""
                    if !packageName.isEmpty, !minimumVersion.isEmpty {
                        actionCodeSettings.setAndroidPackageName(packageName, installIfNotAvailable: false, minimumVersion: minimumVersion)
                    }

                    providers.append(
                        FUIEmailAuth(authAuthUI: authUI,
                                     signInMethod: EmailLinkAuthSignInMethod,
                                     forceSameDevice: false,
                                     allowNewEmailAccounts: true,
                                     requireDisplayName: requireDisplayName,
                                     actionCodeSetting: actionCodeSettings)
                    )
                } else {
                    // the email & password sign-in method.
                    providers.append(
                        FUIEmailAuth(authAuthUI: authUI,
                                     signInMethod: EmailPasswordAuthSignInMethod,
                                     forceSameDevice: false,
                                     allowNewEmailAccounts: true,
                                     requireDisplayName: requireDisplayName,
                                     actionCodeSetting: actionCodeSettings)
                    )
                }
            case "Phone" :
                providers.append(FUIPhoneAuth(authUI: authUI))
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
