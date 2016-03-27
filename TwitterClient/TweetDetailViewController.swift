//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Lam Hieu on 3/26/16.
//  Copyright © 2016 Lam Hieu. All rights reserved.
//

import UIKit
import AFNetworking


class TweetDetailViewController: UIViewController {

    @IBOutlet weak var tweetImageProfile: UIImageView!
    @IBOutlet weak var tweetUsernameLabel: UILabel!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextlabel: UILabel!
    @IBOutlet weak var tweetTimestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweetDetail: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetUsernameLabel.text = tweetDetail!.userName
        tweetScreenNameLabel.text = "@\(tweetDetail!.userScreenName!)"
        tweetTextlabel.text = tweetDetail!.text as? String
        tweetImageProfile.setImageWithURL((tweetDetail!.userImageProfile)!)
        retweetCountLabel.text = String((tweetDetail!.retweetCount))
        favoriteCountLabel.text = String((tweetDetail!.favouritesCount))
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy 'at' h:mm aaa"
        tweetTimestampLabel.text = formatter.stringFromDate(self.tweetDetail!.timestamp!)
        
        tweetImageProfile.layer.cornerRadius = 5
        tweetImageProfile.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
