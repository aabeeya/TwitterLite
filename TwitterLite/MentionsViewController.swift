//
//  MentionsViewController.swift
//  TwitterLite
//
//  Created by Aabeeya on 10/8/17.
//  Copyright © 2017 Aabeeya. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mentionsTableView: UITableView!
    var tweets: [Tweet]!

    override func viewDidLoad() {
        super.viewDidLoad()
        mentionsTableView.dataSource = self
        mentionsTableView.delegate = self

        mentionsTableView.rowHeight = UITableViewAutomaticDimension
        mentionsTableView.estimatedRowHeight = 300

        TwitterClient.sharedInstance?.mentionsTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets

            self.mentionsTableView.reloadData()

        }, failure: { (error: NSError) in
            print (error.localizedDescription)
        })
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mentionsTableView.dequeueReusableCell(withIdentifier: "HomeFeedCell", for: indexPath) as! HomeFeedCell
        cell.tweet = tweets[indexPath.row]

        return cell

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweetsArray = tweets {
            return tweetsArray.count
        } else {
            return 0
        }
    }

}
