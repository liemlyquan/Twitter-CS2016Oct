//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Liem Ly Quan on 10/30/16.
//  Copyright © 2016 liemlyquan. All rights reserved.
//

import UIKit

protocol NewTweeViewControllerDelegate {
    func tweetButtonDidTap(newTweetViewController: NewTweetViewController, tweet: Tweet)
}

class NewTweetViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var counterLabel: UIBarButtonItem!
    
    let tweeterCharacterLimit = 140
    var userData: User!
    
    
    
    var replyToScreenName: String?
    var replyToStatusId: Int?
    
    var delegate: NewTweeViewControllerDelegate?
    
    override func viewDidLoad() {
        initDelegate()
        initData()
        initUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initDelegate(){
        tweetTextView.delegate = self
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
        
        if let replyToStatusId = replyToStatusId,
            let replyToScreenName = replyToScreenName
        {
            // TODO add code here
            tweetTextView.text.append("@\(replyToScreenName) ")
        }
    }
    
    @IBAction func onCancelButtonTapped(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweetButtonTapped(_ sender: UIBarButtonItem){
        if let status = tweetTextView.text {
            var parameters:Dictionary<String,AnyObject> = [:]
            parameters["status"] = status as AnyObject
            
            if let replyToStatusId = replyToStatusId {
                parameters["in_reply_to_status_id"] = replyToStatusId as AnyObject
            }
            
            TwitterClient.sharedInstance?.createTweetWithCompletion(
                parameters: parameters,
                completion: { (tweet, error) in
                    if let tweet = tweet {
                        self.delegate?.tweetButtonDidTap(newTweetViewController: self, tweet: tweet)
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                }
            )
        }
    }
}

extension NewTweetViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        counterLabel.title = "\(tweeterCharacterLimit - textView.text.characters.count)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.characters.count >= tweeterCharacterLimit {
            return false
        }
        if let replyToScreenName = replyToScreenName {
            if 0 ... replyToScreenName.characters.count + 1 ~= range.location  {
                return false
            }
        }

        return true
    }
}
