//
//  TweetCell.swift
//  Twitter
//
//  Created by Udgam Goyal on 6/28/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var favoriteCountLabel: UILabel!

    @IBOutlet weak var youRetweeted: UILabel!
    @IBOutlet weak var retweetTopLabel: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var profPicImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var tweet: Tweet!{
        didSet{
            tweetLabel.text = tweet.text as! String
            timestampLabel.text = tweet.twitterTimeStamp
            userFullName.text = tweet.user?.name as! String
            usernameLabel.text = "@\(tweet.user?.screenname as! String)"
            retweetCountLabel.text = "\(tweet.retweetCount)"
            
            if tweet.retweeted_status != nil{
                favoriteCountLabel.text = "\(tweet.retweeted_status?.favoritesCount)"
            }
            else{
                print("retweeted status is nil")
                favoriteCountLabel.text = "\(tweet.favoritesCount)"
            }
            profPicImage.layer.cornerRadius = profPicImage.frame.size.width / 10
            profPicImage.clipsToBounds = true
            if (tweet.favoritedByUser == true){
                likeButton.setImage(UIImage(named: "blueLike"), forState: .Normal)
            }
            if (tweet.retweetedByUser == true){ retweetButton.setImage(UIImage(named:"greenRetweet"), forState: .Normal)
                youRetweeted.textColor = UIColor.grayColor()
                retweetTopLabel.setImage(UIImage(named: "retweet"), forState: .Normal)
            }
            let imageURL = tweet.user?.profileURL
            profPicImage.setImageWithURL(imageURL!)
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func favoriteAction(sender: AnyObject) {
        if(tweet.favoritedByUser == false){
            TwitterClient.sharedInstance.favorite(tweet.id!, success: { (favorited: Tweet) in
                print(self.tweet.favoritesCount)
                print(favorited.favoritesCount)
                self.likeButton.setImage(UIImage(named: "blueLike"), forState: .Normal)
                self.favoriteCountLabel.text = "\(self.tweet.favoritesCount + 1)"
                favorited.favoritedByUser = true
                }, failure: { (error: NSError) in
                    
            })
        }
        
    }
    
    
    @IBAction func retweetAction(sender: AnyObject) {
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
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayTweet(){
        
        
    }
    
}
