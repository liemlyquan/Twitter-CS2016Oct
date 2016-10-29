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
    var text: String?
    var createdAt: String?
    var user: User?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map){
        text <- map["text"]
        createdAt <- map["created_at"]
        user <- map["user"]
        
    }
}
