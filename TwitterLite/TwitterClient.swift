//
//  TwitterClient.swift
//  TwitterLite
//
//  Created by Aabeeya on 9/28/17.
//  Copyright © 2017 Aabeeya. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    

    // create a single client to be used throughout the application. Not the mess we created in appDelagate.swift
    // static is same as class except you cant override it
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "6g2J4ePBYnsBVs1cov4OKxQdf", consumerSecret: "YvdzbpDCWbZi7i6rBbRgfuiYB3KtjBOMmKCFqnfmXKcp3epKBV")


    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?


    func login(success: @escaping ()->(), failure: @escaping (NSError) -> ()) {

        /* 
        I am not ready to run success just yet, but i can store it in my instance variable for later
        so when i am ready I have this waiting
        */

        loginSuccess =  success
        loginFailure = failure

        // baseURL means the front path of the URL - prepends this URL infront of all your endpoints
        // fetch request token : Prove to twitter that this is me - the app creator
        // and in the event of suceces pass me my request token, so the method that runs in event of success

        // clear the keychain first to log out
        TwitterClient.sharedInstance?.deauthorize()

        // now fetch the request token
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "mytwitterlite://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential?) -> Void in
            // purpose of this token is to get permisison to send the user to authorize URL -the screeen that we see
            // so create a URL
            let urlString = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)"
            let url = URL(string: urlString)
            // using open URL to open the permissions screen in mobile safari
            UIApplication.shared.open(url!)
        }, failure: { (error: Error!) in
            print("error: \(error.localizedDescription)")
            // Failure i can call right away - also inside closure, so use self.
            self.loginFailure?(error as! NSError)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }

    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            print ("I got the access token!")

            // loginSuccess is called only when login is successful, so makes sense to set the current
            // so first get the current user and then set the current user
            self.currentAccount(success: { (user: User) -> () in
                User.currentUser = user //magic line that will trigger a call to setter and actaully save it
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error as! NSError)
            })
            
            // I am logged in so call login success and give it a call if you can (?)
            self.loginSuccess?()

        }, failure: { (error: Error!) in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error as! NSError)
        })

    }


    
    // When you succeed I want you to have a closure where I will hand you an array of tweets
    // and I don't need a response from you
    // OR
    // in error case just give me the error you are getting
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {

        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in

            let dictionaries = response as! [NSDictionary]

            let tweets = Tweet.tweetsWithArray(dictionaries:dictionaries)

            // on success I am going to hand you back your tweets
            success(tweets)

        }, failure: { (task: URLSessionDataTask?, error: Error!) in
            failure (error as! NSError)
        })

    }
    
    func userTimeLine(userName: String? = nil, success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()){
        var parameters: [String:String] = [:]
        if userName != nil {
            parameters =  ["screen_name": userName!]
        }
        get("1.1/statuses/user_timeline.json", parameters: parameters, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries:dictionaries)
            
            // on success I am going to hand you back your tweets
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error!) in
            failure (error as! NSError)
        })    }



    func currentAccount(success: @escaping (User) -> (), failure: @escaping (NSError) -> ()) {
        
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error!) in
            failure (error as! NSError)
        })

    }
    
    func tweet(text: String, replyTo: String? = nil, success: @escaping() -> (), failure: @escaping (NSError) -> ()) {
        var parameters = ["status": text]
        
        if replyTo != nil {
            parameters["in_reply_to_status"] = replyTo
        }

        post("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error!) in
            failure (error as! NSError)
        })
        
    }
    
    func retweet(id: String, success: @escaping() -> (), failure: @escaping (NSError) -> ()) {
    
        post("1.1/statuses/retweet/" + id + ".json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error!) in
            failure (error as! NSError)
        })
        
    }
    
    func unretweet(id: String, success: @escaping() -> (), failure: @escaping (NSError) -> ()) {
        
        post("1.1/statuses/unretweet/" + id + ".json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error!) in
            failure (error as! NSError)
        })
        
    }
    
    func like(id: String, success: @escaping() -> (), failure: @escaping (NSError) -> ()) {

        post("1.1/favorites/create.json", parameters: ["id": id], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error!) in
            failure (error as! NSError)
        })
        
    }
    
    func unlike(id: String, success: @escaping() -> (), failure: @escaping (NSError) -> ()) {
        
        post("1.1/favorites/destroy.json", parameters: ["id": id], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error!) in
            failure (error as! NSError)
        })
        
    }
    
    func userInfo(userName: String, success: @escaping((User)) -> (), failure: @escaping (NSError) -> ()) {
        
        get("1.1/users/show.json", parameters: ["screen_name": userName], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error!) in
            failure (error as! NSError)
        })
        
    }

    func mentionsTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {

        get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in

            let dictionaries = response as! [NSDictionary]

            let tweets = Tweet.tweetsWithArray(dictionaries:dictionaries)

            // on success I am going to hand you back your tweets
            success(tweets)

        }, failure: { (task: URLSessionDataTask?, error: Error!) in
            failure (error as! NSError)
        })
    }
}
