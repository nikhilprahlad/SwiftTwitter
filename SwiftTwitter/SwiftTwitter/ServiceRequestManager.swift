//
//  ServiceRequestManager.swift
//  SwiftTwitter
//
//  Created by Nikhil Prahlad on 8/2/15.
//  Copyright (c) 2015 Nikhil Prahlad. All rights reserved.
//

import UIKit
import TwitterKit

class ServiceRequestManager: NSObject {
   
    static let sharedInstance = ServiceRequestManager()
    
    private override init(){
        
    }
    
    func retweet(selectedTweet:Tweet, completion:(retweetedTweet:Tweet)->()){
        
        if(selectedTweet.retweeted ?? false){
            // The Pyramid of Doom. Twitter, why you no give proper API to Undo Retweet? :(
            self.fetchTweetStatus(String(selectedTweet.id!), completion: { (fetchedTweet, error) -> () in
                
                if error == nil {
                    let id:String?
                    if fetchedTweet?.retweetID != nil {
                        id = fetchedTweet?.retweetID
                    } else{
                        id = fetchedTweet?.id
                    }
                    
                    self.destroyTweet(id!, completion: { (fetchedTweet, error) -> () in
                        
                        if error == nil{
                            
                            self.fetchTweetStatus(String(selectedTweet.id!), completion: { (fetchedTweet, error) -> () in
                                if error == nil{
                                    completion(retweetedTweet: fetchedTweet!)
                                }
                            })
                        }
                    })
                }
            })
        }
            
        else{
            
            var params = [String:String]()
            let url = "https://api.twitter.com/1.1/statuses/retweet/\(selectedTweet.id!).json"
            var clientError : NSError?
            
            let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("POST", URL: url, parameters: params, error: &clientError)
            
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request, completion: { (response, data, connectionError) -> Void in
                if(connectionError == nil){
                    
                    self.fetchTweetStatus(String(selectedTweet.id!), completion: { (fetchedTweet, error) -> () in
                        
                        if error == nil{
                            completion(retweetedTweet: fetchedTweet!)
                        }
                    })
                }
            })
        }
    }
    
    func fetchNewTweets(#count:Int, completion:(tweetsArray:Array<NSDictionary>)->()) {
        
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count":"\(count)"]
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        Twitter.sharedInstance().APIClient.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if (connectionError == nil) {
                
                var jsonError : NSError?
                let json : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError)
                #if DEBUG
                    print("Request - \(request)\n")
                    //println("Response - \(json)\n")
                #endif
                if let tweetsArray = json as? Array<NSDictionary>{
                    completion(tweetsArray: tweetsArray)
                }
            }
            else {
                println("Error: \(connectionError)")
            }
        }
    }

    
    func fetchTweetStatus(tweetID:String, completion:(fetchedTweet:Tweet?, error:NSError?)->()) {
        
        var params = ["id":tweetID, "include_my_retweet":"true"]
        let url = "https://api.twitter.com/1.1/statuses/show.json?id=\(tweetID)"
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: url, parameters: params as [NSObject : AnyObject], error: &clientError)
        
        Twitter.sharedInstance().APIClient.sendTwitterRequest(request, completion: { (response, data, connectionError) -> Void in
            if(connectionError == nil){
                
                var jsonError:NSError?
                let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: &jsonError)
                #if DEBUG
                    print("Request - \(request)\n")
                    //println("Response - \(json)\n")
                #endif
                if let retweetedTweetDict = json as? NSDictionary{
                    
                    let retweetedTweet = Tweet(dictionary: retweetedTweetDict)
                    completion(fetchedTweet: retweetedTweet, error: nil)
                }
            }
            else{
                completion(fetchedTweet: nil, error: connectionError)
            }
        })
    }
    
    func destroyTweet(tweetID:String, completion:(fetchedTweet:Tweet?, error:NSError?)->()) {
        
        var params = [String:String]()
        let url = "https://api.twitter.com/1.1/statuses/destroy/\(tweetID).json"
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("POST", URL: url, parameters: params, error: &clientError)
        
        Twitter.sharedInstance().APIClient.sendTwitterRequest(request, completion: { (response, data, connectionError) -> Void in
            if(connectionError == nil){
                
                var jsonError:NSError?
                let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: &jsonError)
                #if DEBUG
                    print("Request - \(request)\n")
                    //println("Response - \(json)\n")
                #endif
                if let retweetedTweetDict = json as? NSDictionary{
                    
                    var fetchedTweet = Tweet(dictionary: retweetedTweetDict)
                    completion(fetchedTweet: fetchedTweet, error: nil)
                }
            }
            else{
                completion(fetchedTweet: nil, error: connectionError)
            }
        })
    }
    
    func destroyFavouritedTweet(tweetID:String, completion:(fetchedTweet:Tweet?, error:NSError?)->()){
        
        var params = ["id":tweetID]
        let url = "https://api.twitter.com/1.1/favorites/destroy.json?id=\(tweetID)"
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("POST", URL: url, parameters: params, error: &clientError)
        
        Twitter.sharedInstance().APIClient.sendTwitterRequest(request, completion: { (response, data, connectionError) -> Void in
            if(connectionError == nil){
                
                var jsonError:NSError?
                let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: &jsonError)
                #if DEBUG
                    print("Request - \(request)\n")
                    //println("Response - \(json)\n")
                #endif
                if let favoritedTweet = json as? NSDictionary{
                    
                    var fetchedTweet = Tweet(dictionary: favoritedTweet)
                    completion(fetchedTweet: fetchedTweet, error: nil)
                }
            }
            else{
                completion(fetchedTweet: nil, error: connectionError)
            }
        })
    }
    
    func favourite(selectedTweet:Tweet, completion:(favoritedTweet:Tweet)->()) {
        
        if(selectedTweet.favorited ?? false){
            
            self.destroyFavouritedTweet(String(selectedTweet.id!), completion: { (fetchedTweet, error) -> () in
                
                if error == nil{
                    
                    self.fetchTweetStatus(String(selectedTweet.id!), completion: { (fetchedTweet, error) -> () in
                        if error == nil{
                            completion(favoritedTweet: fetchedTweet!)
                        }
                    })
                }
            })
        }
            
        else{
            
            var params = ["id":selectedTweet.id!]
            let url = "https://api.twitter.com/1.1/favorites/create.json?id=\(selectedTweet.id!)"
            var clientError : NSError?
            
            let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("POST", URL: url, parameters: params, error: &clientError)
            
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request, completion: { (response, data, connectionError) -> Void in
                if(connectionError == nil){
                    
                    self.fetchTweetStatus(String(selectedTweet.id!), completion: { (fetchedTweet, error) -> () in
                        
                        if error == nil{
                            completion(favoritedTweet: fetchedTweet!)
                        }
                    })
                }
            })
        }
    }
    
    func fetchMentions(#count:Int, completion:(mentionsArray:Array<NSDictionary>)->()){
        
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/mentions_timeline.json"
        let params = ["count":"\(count)"]
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        Twitter.sharedInstance().APIClient.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if (connectionError == nil) {
                
                var jsonError : NSError?
                let json : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError)
                #if DEBUG
                    print("Request - \(request)\n")
                    //println("Response - \(json)\n")
                #endif
                if let tweetsArray = json as? Array<NSDictionary>{
                    completion(mentionsArray: tweetsArray)
                }
            }
            else {
                println("Error: \(connectionError)")
            }
        }
    }
    
    func fetchUserTweets(#userId:String, count:Int, completion:(mentionsArray:Array<NSDictionary>)->()){
        
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let params = ["count":"\(count)"]
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        Twitter.sharedInstance().APIClient.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if (connectionError == nil) {
                
                var jsonError : NSError?
                let json : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError)
                #if DEBUG
                    print("Request - \(request)\n")
                    //println("Response - \(json)\n")
                #endif
                if let tweetsArray = json as? Array<NSDictionary>{
                    completion(mentionsArray: tweetsArray)
                }
            }
            else {
                println("Error: \(connectionError)")
            }
        }
    }
    
    func logout(){
        Twitter.sharedInstance().logOut()
    }
}
