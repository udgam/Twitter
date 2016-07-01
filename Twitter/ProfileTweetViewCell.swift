//
//  ProfileTweetViewCell.swift
//  Twitter
//
//  Created by Udgam Goyal on 6/30/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit

class ProfileTweetViewCell: UITableViewCell {

    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIImageView!
    @IBOutlet weak var retweetButton: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var profPicImage: UIImageView!
    var tweet: Tweet!{
        didSet{
            tweetLabel.text = tweet.text as? String
            userFullNameLabel.text = tweet.user?.name as? String
            timestampLabel.text = tweet.twitterTimeStamp
            usernameLabel.text = "@\(tweet.user?.screenname as! String)"
            retweetCountLabel.text = "\(tweet.retweetCount)"
            favoriteCountLabel.text = "\(tweet.favoritesCount)"
            profPicImage.layer.cornerRadius = profPicImage.frame.size.width / 10
            profPicImage.clipsToBounds = true
            if (tweet.favoritedByUser == true){
                likeButton.image = UIImage(named: "blueLike")
                print("Favorited")
            }
            if (tweet.retweetedByUser == true){ retweetButton.image = UIImage(named:"greenRetweet")
                
            }
            let imageURL = tweet.user?.profileURL
            profPicImage.setImageWithURL(imageURL!)
            
            
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

}
