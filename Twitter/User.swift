//
//  User.swift
//  Twitter
//
//  Created by Liem Ly Quan on 10/25/16.
//  Copyright © 2016 liemlyquan. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    var name: String?
    var profileImageUrl: String?
    var screenName: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map){
        name <- map["name"]
        profileImageUrl <- map["profile_image_url"]
        screenName <- map["screen_name"]
    }
    
    class var currentUser: User? {
        get {
            guard let JSONString = UserDefaults.standard.object(forKey: "currentUser") as? [String : Any] else {
                return nil
            }
            let user = Mapper<User>().map(JSON: JSONString)
            return user
        }
        set(user) {
            guard let user = user else {
                return
            }
            let JSONString = Mapper<User>().toJSON(user)
            UserDefaults.standard.set(JSONString, forKey: "currentUser")
            UserDefaults.standard.synchronize()
        }
    }
}
