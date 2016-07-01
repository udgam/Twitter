//
//  TwitterClient.swift
//  Twitter
//
//  Created by Udgam Goyal on 6/27/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    var logInSuccess: (() -> ())?
    var logInFailure: ((NSError) -> ())?
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "ZVCryPzu27iT5fpNNtOtw0LP6", consumerSecret: "xCRCoBD9UuKsi2swJfJ1dIfkh6pu71uhUDHABXV2bgbxi0Aa7y")
    
    
    func logIn(success: () -> () , failure: (NSError) -> () ){
        
        logInSuccess = success
        logInFailure = failure
    
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
        }) { (error: NSError!) in
            print ("error:\(error.localizedDescription)")
            self.logInFailure?(error)
        }
    
    }
    
    func logOut(){
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogOutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken : BDBOAuth1Credential!) in
            
            self.currentAccount({ (user: User) in
                User.currentUser = user
                self.logInSuccess?()
                
                }, failure: { (error: NSError) in
                    self.logInFailure?(error)
            })
            
        }) { (error: NSError!) in
            print("error:\(error.localizedDescription)")
            self.logInFailure?(error)
        }
    
    }
    
    func homeTimeline(numberOfTweets: Int, success: ([Tweet]) -> (), failure: (NSError) -> ()){
        
        var param = NSDictionary()
        param = ["count": numberOfTweets]
        
        GET("1.1/statuses/home_timeline.json", parameters: param, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                
                failure(error)
        })
        
        
    }
    
    func currentAccount(success: ((User) -> ()), failure: (NSError) -> ()){
        
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            print("account:\(response)")
            let userDictionary = response as? NSDictionary
            let user = User(dictionary: userDictionary!)
            
            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
        
    }
    
    
    func retweet(id: String, success: ((Tweet) -> ()), failure: (NSError) -> ()){
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let dict = response as? NSDictionary
            let tweet = Tweet(dictionary: dict!)
            success(tweet)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    func favorite(id: String, success:((Tweet) -> ()), failure: (NSError) -> ()){
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dict = response as? NSDictionary
            let tweet = Tweet(dictionary: dict!)
            success(tweet)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        }
        
    }
    
    
    func composeTweet(status: String, success:(() -> ()), failure: (NSError -> ())){
        var param = NSDictionary()
        param = ["status": status]
        POST("1.1/statuses/update.json", parameters: param, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
        
    }
    
    func mentions(numberOfTweets: Int, success: ([Tweet]) -> (), failure: (NSError) -> ()){
        var param = NSDictionary()
        param = ["count": numberOfTweets]
        
        GET("1.1/statuses/mentions_timeline.json", parameters: param, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
        
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                
                failure(error)
        })
        
        
    }
    
    func getUserTweets (screen_name: NSString, success: ([Tweet]) -> (), failure: (NSError) -> ()){
        
        var param = NSDictionary()
        param = ["screen_name": screen_name, "exclude_replies": true]
        
        GET("1.1/statuses/user_timeline.json", parameters: param, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                
                failure(error)
        })
        
        
    }
    
    
    
}
