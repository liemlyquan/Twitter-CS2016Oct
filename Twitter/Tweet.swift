//
//  Tweet.swift
//  Twitter
//
//  Created by Liem Ly Quan on 10/24/16.
//  Copyright © 2016 liemlyquan. All rights reserved.
//

import Foundation
import ObjectMapper

class Tweet : Mappable {
    var id: Int?
    var text: String?
    var createdAt: String?
    var user: User?
    var favorited: Bool?
    var retweeted: Bool?
    var retweetCount: Int?
    var favoriteCount: Int?
    var currentUserRetweet: NSDictionary?
    var inReplyToStatusId: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map){
        id <- map["id"]
        text <- map["text"]
        createdAt <- map["created_at"]
        user <- map["user"]
        favorited <- map["favorited"]
        retweeted <- map["retweeted"]
        retweetCount <- map["retweet_count"]
        favoriteCount <- map["favorite_count"]
        currentUserRetweet <- map["current_user_retweet"]
        inReplyToStatusId <- map["in_reply_to_status_id"]
    }
}
