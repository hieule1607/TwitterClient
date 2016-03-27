//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Lam Hieu on 3/25/16.
//  Copyright © 2016 Lam Hieu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "Q2qEFwVRzFKSAFnsvIHRB2C5J", consumerSecret: "kVHY1urp1a0Vii5qtoFaeT5ivhuJkSgOwp1o4iU3M62g0FSrZR")
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //print("account: \(response)")
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            
            //print("username: \(user.name!)")
            }, failure: { (task: NSURLSessionDataTask?, error:NSError) -> Void in
                failure(error)
        })
    }
    func homeTimeline(count: Int?, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        var parameters = [String : AnyObject]()
        // Add parameter the number of records to retrieve
        // default retrive 20 record
        if count != nil {
            parameters["count"] = count
        }
        
        GET("1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (task:NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func composeTweet(parameters: NSDictionary?, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        POST("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task: NSURLSessionTask, response: AnyObject?) -> Void in
            
            }, failure: { (task: NSURLSessionTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func favoriteTweet(idTweet: NSNumber?, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        var parameters = [String : AnyObject]()

        if idTweet != nil {
            parameters["id"] = idTweet
        }
        /*
        if isFavorited != nil {
            parameters["favorited"] = isFavorited
        }
*/
        //print(idTweet)
        POST("1.1/favorites/create.json?id=\(idTweet)", parameters: parameters, progress: nil, success: { (task: NSURLSessionTask, response: AnyObject?) -> Void in
            print("asdasda")
            }, failure: { (task: NSURLSessionTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func deFavoriteTweet(idTweet: NSNumber?, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        var parameters = [String : AnyObject]()
        
        if idTweet != nil {
            parameters["id"] = idTweet
        }
       
        POST("1.1/favorites/destroy.json?id=\(idTweet)", parameters: parameters, progress: nil, success: { (task: NSURLSessionTask, response: AnyObject?) -> Void in
            
            }, failure: { (task: NSURLSessionTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    /*
    func retweetTweet(idTweet: NSNumber?, parameters: NSDictionary?, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        
        POST("1.1/statuses/retweet/\(idTweet).json", parameters: parameters, progress: nil, success: { (task: NSURLSessionTask, response: AnyObject?) -> Void in
            
            }, failure: { (task: NSURLSessionTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    */
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()//clear section previous
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "TwitterClient://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("I got a token!")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
            }) { (error: NSError!) -> Void in
                print("error:\(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenURL(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            //print("I got the access token!")
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            
            }) { (error: NSError!) -> Void in
                print("error:\(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
}
