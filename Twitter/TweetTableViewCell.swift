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
    
    var tweetData: Tweet! {
        didSet {
            nameLabel.text = tweetData.user?.name
            screenNameLabel.text = tweetData.user?.screenName
            tweetTextLabel.text = tweetData.text
            
            createdAtLabel.text = tweetData.createdAt?.getTimeIntervalString()
            guard
                let user = tweetData.user,
                let profileImageUrl = user.profileImageUrl,
                let url = URL(string: profileImageUrl)
            else {
                return
            }
            userProfileImageView.setImageWith(url)
        }
    }

    weak var delegate: TweetTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onRetweetButtonTapped(_ sender: UIButton){
        
    }
    
    @IBAction func onFavoriteButtonTapped(_ sender: UIButton){
        
    }
    
    @IBAction func onReplyButtonTapped(_ sender: UIButton){
        
    }
}
