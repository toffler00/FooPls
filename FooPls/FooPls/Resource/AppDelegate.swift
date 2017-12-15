//
//  AppDelegate.swift

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import FacebookLogin
import FacebookCore

var fbAccessToken: AccessToken?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        // Facebook Login
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //
        GMSServices.provideAPIKey("AIzaSyCK_mUEG0l9-ADYfsuZduyqjL0yub6HHEY")
        GMSPlacesClient.provideAPIKey("AIzaSyCK_mUEG0l9-ADYfsuZduyqjL0yub6HHEY")
        
        return true
    }
    
    open func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if KOSession.handleOpen(url) {
            return true
        } else {
            SDKApplicationDelegate.shared.application(app, open: url, options: options)
            return true
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        KOSession.handleDidEnterBackground()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        KOSession.handleDidBecomeActive()

    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

