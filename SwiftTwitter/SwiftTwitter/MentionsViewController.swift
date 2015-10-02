//
//  MentionsViewController.swift
//  SwiftTwitter
//
//  Created by Nikhil Prahlad on 8/2/15.
//  Copyright (c) 2015 Nikhil Prahlad. All rights reserved.
//

import UIKit

class MentionsViewController: TweetsListBaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "loadNewMentions", forControlEvents: UIControlEvents.ValueChanged)
        
        if self.revealViewController() != nil {
            
            let barButton = UIBarButtonItem(title: "Options", style: UIBarButtonItemStyle.Plain, target: self.revealViewController(), action: "revealToggle:")
            self.navigationItem.leftBarButtonItem = barButton;

        }
        self.navigationItem.title = "Mentions"
        self.loadNewMentions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadNewMentions() {
        
        ServiceRequestManager.sharedInstance.fetchMentions(count:10) { (mentionsArray) -> () in
            
            self.tweets = [Tweet]()
            for tweetDict in mentionsArray{
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
