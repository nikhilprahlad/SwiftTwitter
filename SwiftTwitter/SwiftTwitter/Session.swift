//
//  Session.swift
//  SwiftTwitter
//
//  Created by Nikhil Prahlad on 7/31/15.
//  Copyright (c) 2015 Nikhil Prahlad. All rights reserved.
//

import UIKit

class Session: NSObject {
   
    var currentUser:User?
    static let sharedSession = Session()
    
    private override init(){
        
    }
}
