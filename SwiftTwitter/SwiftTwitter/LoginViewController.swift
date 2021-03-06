    //
//  LoginViewController.swift
//  SwiftTwitter
//
//  Created by Nikhil Prahlad on 6/21/15.
//  Copyright (c) 2015 Nikhil Prahlad. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: TWTRTimelineViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let logInButton = TWTRLogInButton(logInCompletion: {
            (session, error) in
            // play with Twitter session
            if((session) != nil && error == nil){
                
                let params = [String:String]()
                let url = "https://api.twitter.com/1.1/account/verify_credentials.json"
                var clientError : NSError?
                
                let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: url, parameters: params, error: &clientError)
                
                Twitter.sharedInstance().APIClient.sendTwitterRequest(request, completion: { (response, data, connectionError) -> Void in
                    if(connectionError == nil){
                        
                        let json: AnyObject?
                        do {
                            json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                        } catch let error as NSError {
                            print(error)
                            json = nil
                        } catch {
                            fatalError()
                        }
                        #if DEBUG
                        print("Request - \(request)\n", terminator: "")
                        //println("Response - \(json)\n")
                        #endif
                        if let user = json as? NSDictionary{
                            
                            let loggedInUser = User(dictionary: user)
                            Session.sharedSession.currentUser = loggedInUser
                            let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(loggedInUser)
                            NSUserDefaults.standardUserDefaults().setObject(encodedObject, forKey: "loggedInUser")
                            NSUserDefaults.standardUserDefaults().synchronize()
                        }
                        
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isAuthenticated")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let menu = storyboard.instantiateViewControllerWithIdentifier("menuvc") as! MenuViewController
                        let frontView = TimeLineViewController()
                        let frontnavController = UINavigationController(rootViewController: frontView)
                        let revealVC = SWRevealViewController(rearViewController: menu, frontViewController: frontnavController)
                        self.presentViewController(revealVC, animated: true, completion: nil)
                    }
                    else{
                        print("Could not fetch user details", terminator: "")
                    }
                })
                
            }
            
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)

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

}
