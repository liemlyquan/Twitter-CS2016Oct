//
//  LoginViewController.swift
//  Twitter
//
//  Created by Liem Ly Quan on 10/24/16.
//  Copyright © 2016 liemlyquan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapLoginButton(sender: UIButton){
        TwitterClient.sharedInstance?.login() { (token: String?, error: Error?) in
            if let token = token, let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)") {
                UIApplication.shared.open(authURL)
            }
        }
//        TwitterClient.sharedInstance.deauthorize()
//        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "POST", callbackURL: URL(string: "myTwitter://callback")!, scope: nil, success: { (response: BDBOAuth1Credential?) in
//            print("success")
//            print(response?.token)
//            
//            guard let response = response, let token = response.token else {
//                return
//
//            }
//            guard let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)") else {
//                return
//            }
//            
//            UIApplication.shared.open(authURL)
//            
//            
//            }, failure: { (error: Error?) in
//                print(error?.localizedDescription)
//            })
    }


}

