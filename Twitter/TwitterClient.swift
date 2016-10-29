//
//  TwitterClient.swift
//  Twitter
//
//  Created by Liem Ly Quan on 10/25/16.
//  Copyright © 2016 liemlyquan. All rights reserved.
//

import Foundation
import BDBOAuth1Manager
import ObjectMapper


let twitterBaseURL = URL(string: "https://api.twitter.com")
let twitterConsumerKey = "ptahrEGSLILH8kwUibjvGZjyL"
let twitterConsumerSecret = "bogessNWSfZ3jyZEr3TguiPV1RzcUiYPATFL7uvVU4ywFHOMNo"

class TwitterClient: BDBOAuth1SessionManager {
    // http://krakendev.io/blog/the-right-way-to-write-a-singleton
    static let sharedInstance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    var loginCompletion: ((User?, Error?) -> ())?

    
    func loginWithCompletion(completion: @escaping (User?, Error?) -> () ) {
        loginCompletion = completion
        requestSerializer.removeAccessToken()
        
        // fetch request token & redirect to authorization page
        fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string: "LQLTwitter://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential?) in
                guard let requestToken = requestToken,
                    let token = requestToken.token else {
                        return
                }
                let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
                UIApplication.shared.open(authURL)
            },
            failure: { (error: Error?) -> Void in
                self.loginCompletion!(nil, error)
            }
        )
    }
    
    func createTweetWithCompletion(params: NSDictionary, completion: @escaping (Tweet?, Error?) -> ()) {
        post("1.1/statuses/update.json",
             parameters: params,
             progress: nil,
             success: { (operation: URLSessionDataTask, response: Any?) -> Void in
                let tweet = Mapper<Tweet>().map(JSONObject: response)
                completion(tweet, nil)
            },
             failure: { (operation: URLSessionDataTask?, error: Error) -> Void in
                print("error creating tweet")
                completion(nil, error)
        })
    }
    
    func retweetWithCompletion(id: Int, completion: @escaping (Tweet?, Error?) -> ()) {
        post("1.1/statuses/retweet/\(id).json",
            parameters: nil,
            progress: nil,
            success: { (operation: URLSessionDataTask, response: Any?) -> Void in
                let tweet = Mapper<Tweet>().map(JSONObject: response)
                completion(tweet, nil)
            },
            failure: { (operation: URLSessionDataTask?, error: Error) -> Void in
                print("error retweeting")
                completion(nil, error)
        })
    }
    
    
    func favoriteWithCompletion(id: Int?, completion: @escaping (Tweet?, Error?) -> ()) {
        post("1.1/favorites/create.json",
             parameters: NSDictionary(dictionary: ["id": id!]),
             progress: nil,
             success: { (operation: URLSessionDataTask, response: Any?) -> Void in
                let tweet = Mapper<Tweet>().map(JSONObject: response)
                completion(tweet, nil)
            },
             failure: { (operation: URLSessionDataTask?, error: Error) -> Void in
                print("error favoriting")
                completion(nil, error)
        })
    }
    
    
    func openUrl(url: URL){
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential?) in
            print("Successfully got the access token!")
            self.requestSerializer.saveAccessToken(accessToken)
            self.requestCurrentUser()
        }) { (error: Error?) -> Void in
            print("Failed to get access token.")
            self.loginCompletion?(nil, error)
        }
    }
    
    func requestCurrentUser(){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil,
            success: { (operation: URLSessionDataTask, response: Any?) -> Void in
                let user = Mapper<User>().map(JSONObject: response)
                User.currentUser = user
                self.loginCompletion?(user, nil)
            }, failure: { (operation: URLSessionDataTask?, error) -> Void in
                self.loginCompletion!(nil, error)
        })
    }
    
    func getTimeline(params: NSDictionary = [:], completion: @escaping ([Tweet]?, Error?) -> ()) {
        get("1.1/statuses/home_timeline.json",
            parameters: params,
            progress: nil,
            success: { (operation: URLSessionDataTask, response: Any?) -> Void in
                let tweets = Mapper<Tweet>().mapArray(JSONObject: response)
                completion(tweets, nil)
            },
            failure: { (operation: URLSessionDataTask?, error) -> Void in
                completion(nil, error)
        })
    }
}
