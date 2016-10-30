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
    
    var tweetData: Tweet! {
        didSet {
            guard
                let isFavorite = tweetData.favorited,
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
}
