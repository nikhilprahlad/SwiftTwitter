//
//  MyTweetsViewController.swift
//  SwiftTwitter
//
//  Created by Nikhil Prahlad on 8/4/15.
//  Copyright (c) 2015 Nikhil Prahlad. All rights reserved.
//

import UIKit

class MyTweetsViewController: TweetsListBaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "loadNewUserTweets", forControlEvents: UIControlEvents.ValueChanged)
        
        if self.revealViewController() != nil {
            let barButton = UIBarButtonItem(title: "Options", style: UIBarButtonItemStyle.Plain, target: self.revealViewController(), action: "revealToggle:")
            self.navigationItem.leftBarButtonItem = barButton;
        }
        self.navigationItem.title = "My Tweets"
        self.loadNewUserTweets()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadNewUserTweets() {
        
        if let currentUserId = Session.sharedSession.currentUser?.name {
            ServiceRequestManager.sharedInstance.fetchUserTweets(userId: currentUserId, count: 10) { (tweetsArray) -> () in
                
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
}
