//
//  MenuViewController.swift
//  SwiftTwitter
//
//  Created by Nikhil Prahlad on 7/6/15.
//  Copyright (c) 2015 Nikhil Prahlad. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandleName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let loggedInUser = Session.sharedSession.currentUser{
            if let imageURL = loggedInUser.imageURL{
                userImage.sd_setImageWithURL(imageURL)
            }
            if let screenName = loggedInUser.screenName{
                userHandleName.text = "@\(screenName)"
            }
            userName.text = loggedInUser.name
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) 
        switch indexPath.row{
            
        case 0:
            cell.textLabel?.text = "TimeLine"
        case 1:
            cell.textLabel?.text = "Mentions"
        case 2:
            cell.textLabel?.text = "My Tweets"
        case 3:
            cell.textLabel?.text = "Logout"
        default:
            cell.textLabel?.text = ""

        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row{
            
        case 0:
            let timeLineVC = TimeLineViewController()
            let navController = UINavigationController(rootViewController: timeLineVC)
            self.revealViewController().pushFrontViewController(navController, animated: true)
        case 1:
            let mentionsVC = MentionsViewController()
            let navController = UINavigationController(rootViewController: mentionsVC)
            self.revealViewController().pushFrontViewController(navController, animated: true)
        case 2:
            let myTweetsVC = MyTweetsViewController()
            let navController = UINavigationController(rootViewController: myTweetsVC)
            self.revealViewController().pushFrontViewController(navController, animated: true)
        default:
            ServiceRequestManager.sharedInstance.logout()
            let vc = self.storyboard?.instantiateInitialViewController() as UIViewController!
            let window = UIApplication.sharedApplication().delegate!.window!
            window?.rootViewController = vc
            
        }
        
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
