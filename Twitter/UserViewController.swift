//
//  UserViewController.swift
//  Twitter
//
//  Created by Udgam Goyal on 6/29/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var profPicImage: UIImageView!
    var user: User?
    var tweets: [Tweet]?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let user = user{
            userFullNameLabel.text = user.name as? String
            usernameLabel.text = "@\(user.screenname as! String)"
            profPicImage.layer.cornerRadius = profPicImage.frame.size.width / 10
            profPicImage.clipsToBounds = true
            let imageURL = user.profileURL
            profPicImage.setImageWithURL((imageURL!))
            let coverURL = user.profileBannerURL
            coverPhoto.setImageWithURL(coverURL!)
            followerCountLabel.text = "\(user.userFollowers!)"
            followingCountLabel.text = "\(user.userFollowing!)"
            taglineLabel.text = user.tagline as? String
            
            TwitterClient.sharedInstance.getUserTweets(user.screenname!, success:{ (tweets: [Tweet]) in
                
                self.tweets = tweets
                self.tableView.reloadData()
                
            }) { (error: NSError) in
                print("error:\(error.localizedDescription)")
            }
        }
        
        
        
        // Do any additional setup after loading the view.
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let tweets = tweets{
            return tweets.count
        }
        return 0
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        if let tweets = tweets{
            cell.tweet = self.tweets![indexPath.row]
        }
        return cell
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
