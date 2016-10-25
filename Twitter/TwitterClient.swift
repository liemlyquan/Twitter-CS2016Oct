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
    static let sharedInstance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)


    /// Login into Twitter via OAuth1.0
    ///
    /// - parameter withCompletion: Completion result
    func login(withCompletion: @escaping (String?, Error?) -> ()){
        // Log out before login to just to be sure
        self.deauthorize()
        
        return self.fetchRequestToken(withPath: "oauth/request_token", method: "POST", callbackURL: URL(string: "myTwitter://callback")!, scope: nil, success: { (response: BDBOAuth1Credential?) in
            guard let response = response, let token = response.token else {
                return
            }
            withCompletion(token, nil)
            }, failure: { (error: Error?) in
                withCompletion(nil, error)
        })
    }
    

    func loginCompletion(query: String, withCompletion: @escaping (User?, Error?) -> ()){
        let requestToken = BDBOAuth1Credential(queryString: query)
        self.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken!, success: { (credential: BDBOAuth1Credential?) in
            
            self.requestSerializer.saveAccessToken(credential)
            self.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in

                guard let response = response else {
                    return
                }
                let userObject = Mapper<User>().map(JSONObject: response)
                withCompletion(userObject, nil)
                }, failure: { (task: URLSessionDataTask?, error: Error?) in
                    
                    withCompletion(nil, error)
                })
            
            }, failure: { (error: Error?) in
                withCompletion(nil, error)
                
        })
    }
}
