//
//  User.swift
//  TwitterLite
//
//  Created by Aabeeya on 9/27/17.
//  Copyright © 2017 Aabeeya. All rights reserved.
//

import UIKit

class User: NSObject {

    // these will allow us to use fields like user.name, user.scrrename as opposed to dictionary keys - instance properties - available for each instance of the user
    // stored properties. Have space allocated for them
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?

    var dictionary: NSDictionary?

    init(dictionary: NSDictionary){

        // original dictionary for deserialization
        self.dictionary = dictionary

        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String

        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString as String)
        }

        tagline = dictionary["description"]  as? String

    }

    
    static let userDidLogoutNotification =  "UserDidLogout"
    
    // class property - available just from class itself
    // computed property - not actaully a piece of storage associated with variable
    // e.g var firstName, var lastName, are stored, but var fullName will be computed
    // return some logic to add first , last with space.
    // place where you compute that logic is called the getter

    // will store current User in NSUserDefaults, which is a persisted key/value store -saved across restarts - cookies for web

    // hidden class variable
    static var _currentUser: User?
    
    class var currentUser: User? {
        
        // retrieve the user information
        /* when someone calls user.currentUser if _currentUser is nil,
         they will check to see if there is data inside of the currentUserData,
         if there is, then it will convert it back into a user and store into
         _currentUser and return _currentUser
         */
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? NSData
            
                if let userData = userData {
                    let dictionary = try!  JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
            
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }

        // this code will save the user, anytime we set user to anything

        set (user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUser")
            }

            // save to disk
            defaults.synchronize()
        }
    }
}
