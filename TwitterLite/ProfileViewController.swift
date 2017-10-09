//
//  ProfileViewController.swift
//  TwitterLite
//
//  Created by Bilal on 10/6/17.
//  Copyright © 2017 Aabeeya. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var timeLineTableView: UITableView!
    
    var tweets: [Tweet]!
    
    var user: User! {
        didSet {
            view.layoutIfNeeded()

            nameLabel.text = user.name
            handleLabel.text = user.screenname
            tweetsCountLabel.text =  String(format: "%i", user.tweetsCount!)
            followersCountLabel.text = String(format:" %i", user.followerCount!)
            followingCountLabel.text = String(format: "%i", user.followingCount!)
            
            profileImageView.setImageWith(user.profileUrl!)
            headerImageView.setImageWith(user.headerImageUrl!)
            
            timeLineTableView.dataSource = self
            timeLineTableView.delegate =  self
            timeLineTableView.rowHeight = UITableViewAutomaticDimension
            timeLineTableView.estimatedRowHeight = 300
            
            TwitterClient.sharedInstance?.userTimeLine(userName: user.screenname!, success: { (tweets: [Tweet]) in
                self.tweets = tweets
                
                self.timeLineTableView.reloadData()
                
            }, failure: { (error: NSError) in
                print (error.localizedDescription)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweetsArray = tweets {
            return tweetsArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timeLineTableView.dequeueReusableCell(withIdentifier: "HomeFeedCell", for: indexPath) as! HomeFeedCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    @IBAction func onHomeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
