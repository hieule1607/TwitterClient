//
//  Tweet.swift
//  TwitterClient
//
//  Created by Lam Hieu on 3/25/16.
//  Copyright © 2016 Lam Hieu. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: NSDictionary?
    var userImageProfile: NSURL?
    var userName: String?
    var userScreenName: String?
    var userFavoriteCount: Int?
    
    var idTweet: NSNumber?
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favouritesCount: Int = 0
    var favoriteStatus: Bool?
    //var timestampString: NSString?
    
    init(dictionary: NSDictionary) {
        user = dictionary["user"] as? NSDictionary
        userName = user!["name"] as? String
        userScreenName = user!["screen_name"] as? String
        //userFavoriteCount = (user!["favourites_count"] as? Int) ?? 0
        idTweet = dictionary["id"] as? NSNumber
        let imageURLString = user!["profile_image_url"] as? String
        if imageURLString != nil {
            userImageProfile = NSURL(string: imageURLString!)!
        } else {
            userImageProfile = nil
        }
        
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favouritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        favoriteStatus = dictionary["favorited"] as? Bool
        //timestampString = dictionary["created_at"] as? String
        /*
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString as String)
        }
*/
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        timestamp = formatter.dateFromString(dictionary["created_at"] as! String)!
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }

}
