//
//  Tweet.swift
//  SwiftTwitter
//
//  Created by Nikhil Prahlad on 6/23/15.
//  Copyright (c) 2015 Nikhil Prahlad. All rights reserved.
//

import UIKit

class Tweet: NSObject {
   
    var text:String?
    var retweetCount:Int?
    var favouritesCount:Int?
    var id:String?
    var retweeted:Bool?
    var favorited: Bool?
    var user:User?
    var retweetID:String?
    var createdAt:String?
    
    init(dictionary: NSDictionary){
        
        text = dictionary["text"] as? String
        retweetCount = dictionary["retweet_count"] as? Int
        favouritesCount = dictionary["favorite_count"] as? Int
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        id = dictionary["id_str"] as? String
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        retweetID = dictionary["current_user_retweet"]?["id_str"] as? String
        
        if let createdAtString = dictionary["created_at"] as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            let createdAtDate = dateFormatter.dateFromString(createdAtString)
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            createdAt = dateFormatter.stringFromDate(createdAtDate!)
        }
    }
}
