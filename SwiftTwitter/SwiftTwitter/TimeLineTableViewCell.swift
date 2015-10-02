//
//  TimeLineTableViewCell.swift
//  SwiftTwitter
//
//  Created by Nikhil Prahlad on 6/22/15.
//  Copyright (c) 2015 Nikhil Prahlad. All rights reserved.
//

import UIKit

class TimeLineTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetLabel: UITextView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var favouriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var retweetSelected:(()->())?
    var favouriteSelected:(()->())?
    var replySelected:(()->())?
    
    var tweet:Tweet? {
        didSet{
            tweetLabel.text = nil
            tweetLabel.text = tweet?.text
            if let imageURL = self.tweet?.user?.imageURL{
                profilePic.sd_setImageWithURL(imageURL)
            }
            if let name = tweet?.user?.name{
                userName.text = name
            }
            if let screenName = tweet?.user?.screenName{
                userHandle.text = "@\(screenName)"
            }
            if let favCount = tweet?.favouritesCount{
                favouriteCountLabel.text = String(favCount)
            }
            if let retweetCount = tweet?.retweetCount{
                retweetCountLabel.text = String(retweetCount)
            }
            if let createDate = tweet?.createdAt{
                dateLabel.text = createDate
            }
            if tweet?.retweeted ?? false{
                retweetButton.setImage(UIImage(named: "retweet_green"), forState: UIControlState.Normal)
            }
            else{
                retweetButton.setImage(UIImage(named: "retweet_grey"), forState: UIControlState.Normal)
            }
            if tweet?.favorited ?? false{
                favouriteButton.setImage(UIImage(named: "favorite_yellow"), forState: UIControlState.Normal)
            }
            else{
                favouriteButton.setImage(UIImage(named: "favorite_grey"), forState: UIControlState.Normal)
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func retweetClicked(sender: UIButton) {
        self.retweetSelected?()
    }

    @IBAction func favouriteClicked(sender: UIButton) {
        self.favouriteSelected?()
    }
    
    @IBAction func replyClicked(sender: UIButton) {
        self.replySelected?()
    }
    
}
