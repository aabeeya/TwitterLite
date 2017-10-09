//
//  TweetsViewController.swift
//  TwitterLite
//
//  Created by Aabeeya on 9/28/17.
//  Copyright © 2017 Aabeeya. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet] = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets

            self.tableView.reloadData()

        }, failure: { (error: NSError) in
            print (error.localizedDescription)
        })


        //TwitterClient.sharedInstance?.currentAccount()
    }
    
    // Segue to Details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! UINavigationController
        if segue.identifier == "tweetDetailSegue" {
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            let tweet = tweets[indexPath.row]
            let tweetDetailsVC = vc.childViewControllers[0] as! TweetDetailsViewController;
            tweetDetailsVC.tweet = tweet
        }
        if segue.identifier == "profileModalSegue" {
            let tapGestureRecognizer = sender as! UITapGestureRecognizer
            let indexPathRow = tapGestureRecognizer.view?.tag
            let tweet = tweets[indexPathRow!]

            TwitterClient.sharedInstance?.userInfo(userName: tweet.nameHandle!, success: { (user: User) in
                let profileVC = vc.childViewControllers[0] as! ProfileViewController;
                profileVC.user = user
            }, failure: { (error: NSError) in
                print (error.localizedDescription)
            })
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return self.tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFeedCell", for: indexPath) as! HomeFeedCell

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        cell.thumbImageView.addGestureRecognizer(tapGesture)
        cell.thumbImageView.tag = indexPath.row

        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        }, failure: { (error: NSError) in
            print (error.localizedDescription)
        })
    }
    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "profileModalSegue", sender: sender)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
