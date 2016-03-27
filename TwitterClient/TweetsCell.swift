//
//  TweetsCell.swift
//  TwitterClient
//
//  Created by Lam Hieu on 3/25/16.
//  Copyright © 2016 Lam Hieu. All rights reserved.
//

import UIKit

protocol TweetCellReplyDelegate : class {
    func reply(tweetCell: TweetsCell)
}

protocol TweetCellRetweetDelegate : class {
    func retweet(tweetCell: TweetsCell)
}

protocol TweetCellFavoriteDelegate : class {
    func favorite(tweetCell: TweetsCell)
}

class TweetsCell: UITableViewCell {
    
    weak var replyDelegate: TweetCellReplyDelegate?
    weak var retweetDelegate: TweetCellRetweetDelegate?
    weak var favoriteDelegate: TweetCellFavoriteDelegate?
    
    @IBOutlet weak var tweetImageProfile: UIImageView!
    @IBOutlet weak var tweetUsernameLabel: UILabel!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTimestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var favoriteButtonOL: UIButton!
    
    var isFavorited: Bool?
    var idTweet: NSNumber?
    var tweet: Tweet! {
        didSet {
            tweetImageProfile.setImageWithURL(tweet.userImageProfile!)
            tweetUsernameLabel.text = tweet.userName
            tweetScreenNameLabel.text = "@\(tweet.userScreenName!)"
            tweetTimestampLabel.text = timeAgoSinceDate(tweet.timestamp!, numericDates: true)
            tweetTextLabel.text = tweet.text as? String
            retweetCountLabel.text = "\(tweet.retweetCount)"
            
            favoriteCountLabel.text = String((tweet.favouritesCount))
            isFavorited = tweet.favoriteStatus
            idTweet = tweet.idTweet
            
            if isFavorited == true {
                //favoriteButtonOL.imageView!.image = UIImage(named: "favorite_on.png")
                favoriteButtonOL.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
            } else {
                favoriteButtonOL.setImage(UIImage(named: "favorite.png"), forState: UIControlState.Normal)
            }
        
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        favoriteDelegate?.favorite(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tweetImageProfile.layer.cornerRadius = 9
        tweetImageProfile.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
