//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Liem Ly Quan on 10/30/16.
//  Copyright © 2016 liemlyquan. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var userProfileImageView: UIImageView!

    var userData: User!
    
    override func viewDidLoad() {
        initData()
        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initData(){
        guard
            let screenName = userData.screenName,
            let profileImageUrl = userData.profileImageUrl,
            let url = URL(string: profileImageUrl)
            else
        {
            return
        }
        nameLabel.text = userData.name
        screenNameLabel.text = "@\(screenName)"
        userProfileImageView.setImageWith(url)
    }
    
    func initUI(){
        tweetTextView.becomeFirstResponder()
    }
    
    @IBAction func onCancelButtonTapped(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func onTweetButtonTapped(_ sender: UIBarButtonItem){
        if let status = tweetTextView.text {
            TwitterClient.sharedInstance?.createTweetWithCompletion(
                status: status,
                completion: { (tweet, error) in
                    if let tweet = tweet {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            )
        }
    }
}
