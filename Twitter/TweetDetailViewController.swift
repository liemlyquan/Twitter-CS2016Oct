//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Liem Ly Quan on 10/30/16.
//  Copyright © 2016 liemlyquan. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!



    var tweetData:Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newTweetSegue" {
            guard
                let nvc = segue.destination as? UINavigationController,
                let vc = nvc.topViewController as? NewTweetViewController
                else {
                    return
            }
            vc.userData = User.currentUser
        }
    }
    
    func initData(){
        guard
            let isFavorite = tweetData.favorited,
            let isRetweeted = tweetData.retweeted,
            let user = tweetData.user,
            let screenName = user.screenName,
            let profileImageUrl = user.profileImageUrl,
            let url = URL(string: profileImageUrl)
        else
        {
            return
        }
        nameLabel.text = tweetData.user?.name
        screenNameLabel.text = "@\(screenName)"
        tweetTextLabel.text = tweetData.text
        
        createdAtLabel.text = tweetData.createdAt?.dateFormattedString()
        if isFavorite {
            activateStar()
        }
        if isRetweeted {
            activateRetweet()
        }
        userProfileImageView.setImageWith(url)
    }
    
    @IBAction func onRetweetButtonDidTapped(_ sender: UIButton) {
        guard
            let id = tweetData.id else {
                return
        }
        TwitterClient.sharedInstance?.retweetWithCompletion(
            id: id,
            completion: { (tweet, error) in
                guard let _ = tweet else {
                    return
                }
                self.activateRetweet()
            }
        )
    }
    
    @IBAction func onFavoriteButtonDidTapped(_ sender: UIButton) {
        guard
            let id = tweetData.id else {
                return
        }
        TwitterClient.sharedInstance?.favoriteWithCompletion(
            id: id,
            completion: { (tweet, error) in
                guard let _ = tweet else {
                    return
                }
                self.activateStar()
            }
        )
    }
    
    
    @IBAction func replyButtonDidTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "newTweetSegue", sender: self)
    }
    
    
    func activateStar(){
        starButton.setImage(#imageLiteral(resourceName: "star-filled"), for: .normal)
    }
    
    func deactiveStar(){
        starButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
    }
    
    func activateRetweet(){
        retweetButton.setImage(#imageLiteral(resourceName: "retweet-filled"), for: .normal)
    }
    
    func deactiveRetweet(){
        retweetButton.setImage(#imageLiteral(resourceName: "retweet"), for: .normal)
    }
    
}
