//
//  Tweet.swift
//  Twitter
//
//  Created by Udgam Goyal on 6/27/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit
import PrettyTimestamp

class Tweet: NSObject {
    
    var text: NSString?
    var timeStamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?
    var twitterTimeStamp: String?
    var favoritedByUser: Bool?
    var retweetedByUser: Bool?
    var dict: NSDictionary?
    var id: String?
    var userFollowers: Int?
    var userFollowing: Int?
    var retweeted_status: Tweet?
    
    init(dictionary: NSDictionary){
        dict = dictionary
        let userDict = dictionary["user"] as? NSDictionary
        if let userDict = userDict{
            user = User(dictionary: userDict)
            userFollowers = (userDict["followers_count"] as? Int) ?? 0
            userFollowing = (userDict["friends_count"] as? Int) ?? 0
        }
        id = dictionary["id_str"] as? String
        text = dictionary["text"] as? NSString
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        retweeted_status = dictionary["retweeted_status"] as? Tweet
        
        
        retweetedByUser = dictionary["retweeted"] as? Bool
        favoritedByUser = dictionary["favorited"] as? Bool
        
        let timeStampString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        if let timeStampString = timeStampString{
            timeStamp = formatter.dateFromString(timeStampString)
            twitterTimeStamp = timeStamp?.prettyTimestampSinceNow()
        }
        
        
        
    }
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dict in dictionaries{
            let tweet = Tweet(dictionary: dict)
            tweets.append(tweet)
        }
        return tweets
        
    }
    
    
    
}
