//
//  User.swift
//  Twitter
//
//  Created by Udgam Goyal on 6/27/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: NSString?
    var screenname: NSString?
    var profileURL: NSURL?
    var profileBannerURL: NSURL?
    var tagline: NSString?
    var dictionary: NSDictionary?
    var userFollowers: Int?
    var userFollowing: Int?
    
    static let userDidLogOutNotification = "UserDidLogOut"
    
    
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        name  = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let profileURLString = dictionary["profile_image_url_https"] as? String
        
        if let profileURLString = profileURLString{
            let p = profileURLString.stringByReplacingOccurrencesOfString("_normal", withString: "")
            profileURL = NSURL(string: p)
        }
        let profileBannerURLString = dictionary["profile_banner_url"] as? String
        if let profileBannerURLString = profileBannerURLString{
            let clean = profileBannerURLString.stringByReplacingOccurrencesOfString("_normal", withString: "")
            profileBannerURL = NSURL(string: clean)
        }
        tagline = dictionary["description"] as? String
        userFollowers = (dictionary["followers_count"] as? Int) ?? 0
        userFollowing = (dictionary["friends_count"] as? Int) ?? 0
        
    }
    
    static var _currentUser: User?
    
    
    class var currentUser: User?{
        get{
            
            if _currentUser == nil{
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                
                if let userData = userData{
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
            return _currentUser
            
        }
        
        set(user){
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user{
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            }
            else{
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
}
