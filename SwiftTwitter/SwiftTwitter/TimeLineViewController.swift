//
//  ViewController.swift
//  SwiftTwitter
//
//  Created by Nikhil Prahlad on 6/20/15.
//  Copyright (c) 2015 Nikhil Prahlad. All rights reserved.
//

import UIKit
import TwitterKit

class TimeLineViewController: TweetsListBaseTableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "loadNewTweets", forControlEvents: UIControlEvents.ValueChanged)
        
        if self.revealViewController() != nil{
            let leftBarButton = UIBarButtonItem(title: "Options", style: UIBarButtonItemStyle.Plain, target: self.revealViewController(), action: "revealToggle:")
            self.navigationItem.leftBarButtonItem = leftBarButton;
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let rightBarButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Plain, target: self, action: "ComposeTweet:")
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.title = "Timeline"
        
        self.loadNewTweets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ComposeTweet(sender: UIBarButtonItem) {
        
        let myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let composeVC = myStoryBoard.instantiateViewControllerWithIdentifier("ctvc") as! ComposeTweetViewController
        composeVC.tweetType = ComposeTweetViewController.tweetTypes.NewTweet
        self.navigationController?.presentViewController(composeVC, animated: true, completion: nil)
    }
    
    func loadNewTweets() {
        
        ServiceRequestManager.sharedInstance.fetchNewTweets(count: 100) { (tweetsArray) -> () in
            
            self.tweets = [Tweet]()
            for tweetDict in tweetsArray{
                self.tweets?.append(Tweet(dictionary: tweetDict))
            }
            self.tableView.reloadData()
            if let refreshControl = self.refreshControl {
                if refreshControl.refreshing{
                    refreshControl.endRefreshing()
                }
            }
        }
    }
}
