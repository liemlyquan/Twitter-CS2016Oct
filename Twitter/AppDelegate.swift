//
//  AppDelegate.swift
//  Twitter
//
//  Created by Liem Ly Quan on 10/24/16.
//  Copyright © 2016 liemlyquan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import ObjectMapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let query = url.query else {
            return false
        }
        
        TwitterClient.sharedInstance?.loginCompletion(query: query) { (response: AnyObject?, error: Error?) in
            
        }
//        let baseURL = "https://api.twitter.com"
//        
//        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: baseURL), consumerKey: "ptahrEGSLILH8kwUibjvGZjyL", consumerSecret: "bogessNWSfZ3jyZEr3TguiPV1RzcUiYPATFL7uvVU4ywFHOMNo")
//        
//        let requestToken = BDBOAuth1Credential(queryString: url.query)
//        twitterClient?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken!, success: { (response: BDBOAuth1Credential?) in
//            guard let response = response,
//                let token = response.token else {
//                    return
//            }
//            
//            twitterClient?.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
//                
//                
//                }, failure: { (task: URLSessionDataTask?, error: Error?) in
//                    
//                })
//            }, failure: { (error: Error?) in
//        
//        })
        return true
    }


}

