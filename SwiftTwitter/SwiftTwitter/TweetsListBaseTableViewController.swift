//
//  TweetsListBaseTableViewController.swift
//  SwiftTwitter
//
//  Created by Nikhil Prahlad on 8/17/15.
//  Copyright (c) 2015 Nikhil Prahlad. All rights reserved.
//

import UIKit

class TweetsListBaseTableViewController: UITableViewController {
    var tweets:[Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 68
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerNib(UINib(nibName: "TimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if let tweet = self.tweets{
            return tweet.count
        } else{
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let tableCell:TimeLineTableViewCell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TimeLineTableViewCell
        tableCell.tweet = tweets?[indexPath.row]
        if let topCOntroller = self.navigationController?.topViewController {
            if topCOntroller.isKindOfClass(MyTweetsViewController) {
                tableCell.retweetButton.userInteractionEnabled = false
            } else{
                tableCell.retweetButton.userInteractionEnabled = true
            }
        }
        tableCell.retweetSelected = {
            ServiceRequestManager.sharedInstance.retweet(tableCell.tweet!, completion: { (retweetedTweet:Tweet) -> () in
                
                self.tweets?[indexPath.row] = retweetedTweet
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            })
        }
        tableCell.favouriteSelected = {
            ServiceRequestManager.sharedInstance.favourite(tableCell.tweet!, completion: { (favoritedTweet) -> () in
                
                self.tweets?[indexPath.row] = favoritedTweet
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            })
        }
        tableCell.replySelected = {
            let myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let composeVC = myStoryBoard.instantiateViewControllerWithIdentifier("ctvc") as! ComposeTweetViewController
            composeVC.respondingTweet = tableCell.tweet
            composeVC.tweetType = ComposeTweetViewController.tweetTypes.ResponseTweet
            self.navigationController?.presentViewController(composeVC, animated: true, completion: nil)
        }
        
        return tableCell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
}
