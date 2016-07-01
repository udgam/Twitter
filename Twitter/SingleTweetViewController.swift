//
//  SingleTweetViewController.swift
//  Twitter
//
//  Created by Udgam Goyal on 6/29/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit

class SingleTweetViewController: UIViewController {
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var profPicImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    var tweet: Tweet!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tweetLabel.text = tweet.text as! String
        timeLabel.text = tweet.twitterTimeStamp
        userFullNameLabel.text = tweet.user?.name as! String
        usernameLabel.text = "@\(tweet.user?.screenname as! String)"
        profPicImage.layer.cornerRadius = profPicImage.frame.size.width / 10
        profPicImage.clipsToBounds = true
        let imageURL = tweet.user?.profileURL
        profPicImage.setImageWithURL((imageURL!))
        retweetCountLabel.text = "\(tweet.retweetCount)"
        favoriteCountLabel.text = "\(tweet.favoritesCount)"
        if (tweet.favoritedByUser == true){
            likeButton.setImage(UIImage(named: "blueLike"), forState: .Normal)
            print("Favorited")
        }
        if (tweet.retweetedByUser == true){ retweetButton.setImage(UIImage(named:"greenRetweet"), forState: .Normal)
        }

        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retweetInDetailsAction(sender: AnyObject) {
        if (tweet.retweetedByUser == false){
            TwitterClient.sharedInstance.retweet(tweet.id!, success: { (retweeted: Tweet) in
                //self.tweet = retweeted
                self.retweetButton.setImage(UIImage(named:"greenRetweet"), forState: .Normal)
                self.retweetCountLabel.text = "\(self.tweet.retweetCount + 1)"
                retweeted.retweetedByUser = true
                
                }, failure: { (error: NSError) in
                    print("error:\(error.localizedDescription)")
                    
            })
        }
    }
    
    @IBAction func favoriteInDetailsAction(sender: AnyObject) {
        
        if(tweet.favoritedByUser == false){
            TwitterClient.sharedInstance.favorite(tweet.id!, success: { (favorited: Tweet) in
                print(self.tweet.favoritesCount)
                print(favorited.favoritesCount)
                self.likeButton.setImage(UIImage(named: "blueLike"), forState: .Normal)
                self.favoriteCountLabel.text = "\(self.tweet.favoritesCount + 1)"
                favorited.favoritedByUser = true
                }, failure: { (error: NSError) in
                    print("error:\(error.localizedDescription)")
            })
            
        }
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     
    
}
