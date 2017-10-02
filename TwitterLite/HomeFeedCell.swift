//
//  HomeFeedCell.swift
//  TwitterLite
//
//  Created by Aabeeya on 9/30/17.
//  Copyright © 2017 Aabeeya. All rights reserved.
//

import UIKit
import NSDateMinimalTimeAgo


class HomeFeedCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var timeTweeted: UILabel!
    
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!

    var tweet: Tweet! {
        didSet {
            thumbImageView.setImageWith(tweet.profileImageURL!)
            tweetText.text = tweet.text
            nameLabel.text = tweet.userName
            handle.text = "@\(tweet.nameHandle!)"
            
            if (tweet.retweeted) {
                retweetImageView.image = UIImage(named: "retweet-green")
            } else {
                retweetImageView.image = UIImage(named: "retweet-black")
            }
            
            if (tweet.favorited) {
                favoriteImageView.image = UIImage(named: "heart-red")
            } else {
                favoriteImageView.image = UIImage(named: "heart-clear")
            }
            
            timeTweeted.text = nil
            if let tweetDate = tweet.timestamp {
                timeTweeted.text = HomeFeedCell.formatter(tweetDate)
            }
        }
    }
    
    // MARK: - Static variables
    static let indentifier = "HomeFeedCell"
    static let formatter = { (tweetDate: Date) -> String in
        // Code from the following Stack Overflow answer
        // https://stackoverflow.com/a/40827887
        
        //getting the current time
        let now = Date()
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1 //increase it if you want more precision
        
        return formatter.string(from: tweetDate, to: now)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
