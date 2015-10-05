//
//  ComposeTweetViewController.swift
//  SwiftTwitter
//
//  Created by Nikhil Prahlad on 7/19/15.
//  Copyright (c) 2015 Nikhil Prahlad. All rights reserved.
//

import UIKit
import TwitterKit

class ComposeTweetViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var composerTextView: UITextView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    enum tweetTypes{
        
        case NewTweet
        case ResponseTweet
    }
    var tweetType:tweetTypes = tweetTypes.NewTweet
    var respondingTweet:Tweet?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let loggedinUser = Session.sharedSession.currentUser {
            if let imageUrl = loggedinUser.imageURL {
                profileImageView.sd_setImageWithURL(imageUrl)
                userName.text = loggedinUser.name
            }
        }
        
        if tweetType == tweetTypes.ResponseTweet{
            if let screenName = respondingTweet?.user?.screenName{
                composerTextView.text = "@\(screenName)"
            }
        }
        composerTextView.becomeFirstResponder()
        characterCountLabel.text = String(140 - composerTextView.text.characters.count)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func sendTweet(sender: UIBarButtonItem) {
        
        let params = ["status":composerTextView.text]
        let url = "https://api.twitter.com/1.1/statuses/update.json"
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("POST", URL: url, parameters: params, error: &clientError)
        
        Twitter.sharedInstance().APIClient.sendTwitterRequest(request, completion: { (response, data, connectionError) -> Void in
            if(connectionError == nil){
                print("Tweet Sent - \(response!)", terminator: "")
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func textViewDidChange(textView: UITextView) {
        
        characterCountLabel.text = String(140 - textView.text.characters.count)
        if textView.text.characters.count > 140{
            characterCountLabel.textColor = UIColor.redColor()
        } else{
            characterCountLabel.textColor = UIColor.blackColor()
        }
    }
    

}
