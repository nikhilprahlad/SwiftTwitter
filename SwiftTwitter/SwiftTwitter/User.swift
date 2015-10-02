//
//  User.swift
//  SwiftTwitter
//
//  Created by Nikhil Prahlad on 6/23/15.
//  Copyright (c) 2015 Nikhil Prahlad. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
   
    var screenName:String?
    var imageURL:NSURL?
    var name:String?
    
     init(dictionary:NSDictionary){
        
        screenName = dictionary["screen_name"] as? String
        imageURL = NSURL(string: dictionary["profile_image_url"] as! String)
        name = dictionary["name"] as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.screenName, forKey: "screenName")
        aCoder.encodeObject(self.imageURL, forKey: "imageURL")
        aCoder.encodeObject(self.name, forKey: "name")
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.screenName = aDecoder.decodeObjectForKey("screenName") as? String
        self.imageURL = aDecoder.decodeObjectForKey("imageURL") as? NSURL
        self.name = aDecoder.decodeObjectForKey("name") as? String
    }
    
    
}
