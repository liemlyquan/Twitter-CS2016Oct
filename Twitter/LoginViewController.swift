//
//  LoginViewController.swift
//  Twitter
//
//  Created by Liem Ly Quan on 10/24/16.
//  Copyright © 2016 liemlyquan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import ObjectMapper

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLogin()
    }
    
    func checkLogin(){

    }

    
    @IBAction func onTapLoginButton(sender: UIButton){
        TwitterClient.sharedInstance?.loginWithCompletion {
            (user: User?, error: Error?)-> Void in
            if let _ = user {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            } 
        }
    }
}

