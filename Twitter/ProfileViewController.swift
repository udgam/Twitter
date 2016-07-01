//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Udgam Goyal on 6/30/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var timelineControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var profPicImage: UIImageView!
    var numberOfTweets = 20
    var tweets: [Tweet] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = User.currentUser {
            
            TwitterClient.sharedInstance.getUserTweets(user.screenname!, success:{ (tweets: [Tweet]) in
                
                self.tweets = tweets
                self.tableView.reloadData()
                
            }) { (error: NSError) in
                print("error:\(error.localizedDescription)")
            }
            
            tableView.delegate = self
            tableView.dataSource = self
            let coverPhotoURL = user.profileBannerURL
            coverPhoto.setImageWithURL(coverPhotoURL!)
            userFullNameLabel.text = user.name as? String
            usernameLabel.text = "@\(user.screenname as! String)"
            profPicImage.layer.cornerRadius = profPicImage.frame.size.width / 10
            profPicImage.clipsToBounds = true
            let imageURL = user.profileURL
            profPicImage.setImageWithURL((imageURL!))
            
            followerCountLabel.text = "\(user.userFollowers!)"
            followingCountLabel.text = "\(user.userFollowing!)"
            taglineLabel.text = user.tagline as? String
        }else{
            print("user is nil!")
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.tweets.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileTweetViewCell", forIndexPath: indexPath) as! ProfileTweetViewCell
        cell.tweet = self.tweets[indexPath.row]
        return cell
    }
    
    func checkTimelineType(){
        if timelineControl.selectedSegmentIndex == 0{
            TwitterClient.sharedInstance.getUserTweets((User.currentUser?.screenname)!, success: { (userTweets: [Tweet]) in
                self.tweets = userTweets
                self.tableView.reloadData()
                }, failure: { (error: NSError) in
                    print ("error in primary selected")
            })
            
        }
        if timelineControl.selectedSegmentIndex == 1{
            TwitterClient.sharedInstance.mentions(numberOfTweets, success: { (mentions: [Tweet]) in
                self.tweets = mentions
                self.tableView.reloadData()
                }, failure: { (error: NSError) in
                    print("error in primary selected")
            })
            
        }
        
        
    }
    
    @IBAction func primarySelected(sender: AnyObject) {
        checkTimelineType()
    }
    
    @IBAction func indexChanged(sender: AnyObject) {
        checkTimelineType()
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
