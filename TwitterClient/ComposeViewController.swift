//
//  ComposeViewController.swift
//  TwitterClient
//
//  Created by Lam Hieu on 3/26/16.
//  Copyright © 2016 Lam Hieu. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var accountImageProfile: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountScreenNameLabel: UILabel!
    @IBOutlet weak var remainingCharactersLabel: UILabel!
    @IBOutlet weak var composeTextView: UITextView!
    
    var currentUser: User!
    let MAX_CHARACTERS = 140

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwitterClient.sharedInstance.currentAccount({ (user: User) -> () in
            
            self.currentUser = user
            self.accountImageProfile.setImageWithURL(self.currentUser!.profileURL!)
            self.accountNameLabel.text = self.currentUser!.name as? String
            self.accountScreenNameLabel.text = "@\(self.currentUser!.screenName!)"

            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        self.remainingCharactersLabel.text = "\(MAX_CHARACTERS)"
        self.composeTextView.becomeFirstResponder()
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweetButton(sender: AnyObject) {
        let status = self.composeTextView.text
        if ((status.length) == 0) {
            return
        }
        
        let params: NSDictionary = [
            "status": status
        ]
        //print(params)
        TwitterClient.sharedInstance.composeTweet(params, success: { (tweets:[Tweet]) -> () in
            
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        self.textViewDidChange(composeTextView)
    }

    func textViewDidChange(textView: UITextView) {
        let status = textView.text
        let charactersRemaining = MAX_CHARACTERS - (status.length)
            self.remainingCharactersLabel.text = "\(charactersRemaining)"
        self.remainingCharactersLabel.textColor = charactersRemaining >= 0 ? .lightGrayColor() : .redColor()
   
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
extension String {
    var length: Int { return characters.count    }  // Swift 2.0
}
