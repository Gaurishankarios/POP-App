//
//  AppDelegate.swift
//  fBDemo
//
//  Created by Parvez Shaikh on 18/02/19.
//  Copyright © 2019 Parvez Shaikh. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import Firebase
import GoogleSignIn

import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
//        FirebaseApp.configure()
        
        
        let status = UserDefaults.standard.bool(forKey: "userlogin") ?? false
//
//        if status{
//            let rootViewController = self.window!.rootViewController as! UINavigationController
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
//            rootViewController.pushViewController(profileViewController, animated: true)
//        }
        
        if status{
            let testController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            
//             let testController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = testController
        }
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        
        return true
    }
    
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
            
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("token is \(token)")
//        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let appId: String = SDKSettings.appId
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }
//        return false
        else{
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
        }
        
    }
    
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        
       
        
        if error != nil {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        print("credential is \(credential)")
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if error != nil {
                // ...
                print("Google Authentification Fail")
                return
            }
            else{
                
                let rootViewController = self.window!.rootViewController as! UINavigationController
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                rootViewController.pushViewController(profileViewController, animated: true)
                
                
                print("Google Authentification Success")
                
                let userId = user.userID                  // For client-side use only!
                let idToken = user.authentication.idToken // Safe to send to the server
                let fullName = user.profile.name
                let givenName = user.profile.givenName
                let familyName = user.profile.familyName
                let email = user.profile.email
                print("user detail is \(String(describing: userId)) id token is \(String(describing: idToken)) \n full name is \(String(describing: fullName)) \n given name is \(String(describing: givenName)) \n family name is \(String(describing: familyName))\n email is \(String(describing: email))")
                
                UserDefaults.standard.set(true, forKey: "userlogin")
            }
            // User is signed in
            // ...
        }
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        AppEventsLogger.activate(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}



