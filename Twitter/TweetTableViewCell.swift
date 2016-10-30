//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Liem Ly Quan on 10/28/16.
//  Copyright © 2016 liemlyquan. All rights reserved.
//

import UIKit
import FormatterKit
import AFNetworking
@objc protocol TweetTableViewCellDelegate {
    @objc optional func retweetButtonDidTapped(_ tweetTableViewCell: TweetTableViewCell)
    @objc optional func favoriteButtonDidTapped(_ tweetTableViewCell: TweetTableViewCell)
    @objc optional func replyButtonDidTapped(_ tweetTableViewCell: TweetTableViewCell)
}

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var tweetData: Tweet! {
        didSet {
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
            
            createdAtLabel.text = tweetData.createdAt?.getTimeIntervalString()
            if isFavorite {
                activateStar()
            } else {
                deactiveStar()
            }
            if isRetweeted {
                activateRetweet()
            } else {
                deactiveRetweet()
            }
            userProfileImageView.setImageWith(url)
            
        }
    }

    weak var delegate: TweetTableViewCellDelegate?

    @IBAction func onRetweetButtonTapped(_ sender: UIButton){
        delegate?.retweetButtonDidTapped!(self)
    }
    
    @IBAction func onFavoriteButtonTapped(_ sender: UIButton){
        delegate?.favoriteButtonDidTapped!(self)
    }
    
    @IBAction func onReplyButtonTapped(_ sender: UIButton){
        delegate?.replyButtonDidTapped!(self)
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
