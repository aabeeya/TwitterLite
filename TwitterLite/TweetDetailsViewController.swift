//
//  TweetDetailsViewController.swift
//  TwitterLite
//
//  Created by Aabeeya on 10/1/17.
//  Copyright © 2017 Aabeeya. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoritedCount: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text =  tweet.userName
        profilePicture.setImageWith(tweet.profileImageURL!)
        handleLabel.text = "@\(tweet.nameHandle!)"
        tweetContent.text = tweet.text
        retweetCount.text = String(tweet.retweetCount)
        favoritedCount.text = String(tweet.favoritesCount)
        dateLabel.text = DateFormatter.localizedString(from: tweet.timestamp!, dateStyle: .short, timeStyle: .short)
        
        if (tweet.retweeted) {
            retweetButton.setImage(UIImage(named:"retweet-green"), for: .normal)
        } else {
            retweetButton.setImage(UIImage(named:"retweet-black"), for: .normal)
        }
        
        if (tweet.favorited) {
            favoriteButton.setImage(UIImage(named:"heart-red"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named:"heart-clear"), for: .normal)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onHomeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // Segue to Details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! UINavigationController
        if segue.identifier == "replySegue" {
            let replyVC = vc.childViewControllers[0] as! ComposeViewController;
            replyVC.replyId = self.tweet.id;
        }
    }

    @IBAction func onRetweetPressed(_ sender: Any) {
        if (self.tweet.retweeted) {
            TwitterClient.sharedInstance?.unretweet(id: self.tweet.id!, success: {() in
                self.tweet.retweeted = false;
                self.tweet.retweetCount -= 1;
                self.retweetCount.text = String(self.tweet.retweetCount)
                self.retweetButton.setImage(UIImage(named:"retweet-black"), for: .normal)
                
            }, failure: { (error: NSError) in
                print (error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.retweet(id: self.tweet.id!, success: {() in
                self.tweet.retweeted = true;
                self.tweet.retweetCount += 1;
                self.retweetCount.text = String(self.tweet.retweetCount)
                self.retweetButton.setImage(UIImage(named:"retweet-green"), for: .normal)
            }, failure: { (error: NSError) in
                print (error.localizedDescription)
            })
        }
     }
    
    @IBAction func onFavoritePressed(_ sender: Any) {
        if (self.tweet.favorited) {
            TwitterClient.sharedInstance?.unlike(id: self.tweet.id!, success: {() in
                self.tweet.favorited = false;
                self.tweet.favoritesCount -= 1;
                self.favoritedCount.text = String(self.tweet.favoritesCount)
                self.favoriteButton.setImage(UIImage(named:"heart-clear"), for: .normal)
                
            }, failure: { (error: NSError) in
                print (error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.like(id: self.tweet.id!, success: {() in
                self.tweet.favorited = true;
                self.tweet.favoritesCount += 1;
                self.favoritedCount.text = String(self.tweet.favoritesCount)
                self.favoriteButton.setImage(UIImage(named:"heart-red"), for: .normal)
            }, failure: { (error: NSError) in
                print (error.localizedDescription)
            })
        }
    }
    
}
