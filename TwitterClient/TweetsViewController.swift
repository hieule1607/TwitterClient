//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Lam Hieu on 3/25/16.
//  Copyright © 2016 Lam Hieu. All rights reserved.
//

import UIKit


class TweetsViewController: UIViewController, TweetCellFavoriteDelegate {

    var tweets: [Tweet]!
    var tweetDetail = Tweet?()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        TwitterClient.sharedInstance.homeTimeline(20, success: { (tweets: [Tweet]) -> () in
    
            self.tweets = tweets
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
    }
    
    func favorite(tweetCell: TweetsCell) {
        if tweetCell.isFavorited == false {
            let id = tweetCell.idTweet
            TwitterClient.sharedInstance.favoriteTweet(id, success: { (tweets:[Tweet]) -> () in
                tweetCell.favoriteButtonOL.imageView?.image = UIImage(named: "favorite_on.png")
                let thisTweet = tweetCell.tweet! as Tweet
                if thisTweet.favouritesCount > 0 {
                    tweetCell.favoriteCountLabel.text = "\(thisTweet.favouritesCount + 1)"
                } else {
                    tweetCell.favoriteCountLabel.text = "1"
                }
               
                
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
            
        } else {
            
            TwitterClient.sharedInstance.deFavoriteTweet(tweetCell.idTweet, success: { (tweets: [Tweet]) -> () in
                tweetCell.favoriteButtonOL.imageView?.image = UIImage(named: "favorite.png")
                let thisTweet = tweetCell.tweet! as Tweet
                if thisTweet.favouritesCount > 0 {
                    tweetCell.favoriteCountLabel.text = "\(thisTweet.favouritesCount - 1)"
                } else {
                    tweetCell.favoriteCountLabel.text = "0"
                }
               
                
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
        }
        
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "detailTweetSegue" {            
            let selectedIndexPath = self.tableView.indexPathForCell(sender as! TweetsCell)
            let selectedCell = tweets[(selectedIndexPath?.row)!]
            tweetDetail = selectedCell

            let detailTweetViewController = segue.destinationViewController as! TweetDetailViewController

        detailTweetViewController.tweetDetail = self.tweetDetail
        }
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        TwitterClient.sharedInstance.homeTimeline(20, success: { (tweets: [Tweet]) -> () in
            
            self.tweets = tweets
           
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
            print(tweets.count)
            refreshControl.endRefreshing()
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        
    }

}
extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetsCell
        cell.favoriteDelegate = self

        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
}
