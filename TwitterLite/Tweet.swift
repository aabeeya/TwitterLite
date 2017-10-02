//
//  Tweet.swift
//  TwitterLite
//
//  Created by Aabeeya on 9/27/17.
//  Copyright © 2017 Aabeeya. All rights reserved.
//

import UIKit


class Tweet: NSObject {

    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var favorited: Bool = false
    var retweeted: Bool = false
    var userName: String?
    var nameHandle: String?
    var profileImageURL: URL?
    var id: String?
    var retweet_id: String?

    init(dicitonary: NSDictionary){
        
        text = dicitonary["text"] as? String

        retweetCount =  (dicitonary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dicitonary["favorites_count"] as? Int) ?? 0
        retweeted = (dicitonary["retweeted"] as? Bool) ?? false
        favorited = (dicitonary["favorited"] as? Bool) ?? false
        id = dicitonary["id_str"] as? String

        if let timeStampString = dicitonary["created_at"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            timestamp = dateFormatter.date(from: timeStampString)
        }

        
        let user = dicitonary["user"] as? NSDictionary
        if user != nil {
            userName = user!["name"] as? String
            nameHandle = user!["screen_name"] as? String
            
            let imageURLString = user!["profile_image_url"] as? String
            if imageURLString != nil {
                profileImageURL = URL(string: imageURLString!)!
            } else {
                profileImageURL = nil
            }
        }
        
        if let retweet = dicitonary["retweeted_status"] as? NSDictionary {
            retweet_id = retweet["id_str"] as? String
        }
    }

    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {

        // creata an empty array of tweets
        var tweets = [Tweet]()

        // iterate through all the dictionaries
        for dictionary in dictionaries {

            // create a tweet based on dicitonary
            let tweet = Tweet(dicitonary: dictionary)

            // add tweet to array
            tweets.append(tweet)
        }

        // return the array of tweets
        return tweets
    }
}
