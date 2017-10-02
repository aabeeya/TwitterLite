//
//  ComposeViewController.swift
//  TwitterLite
//
//  Created by Aabeeya on 10/1/17.
//  Copyright © 2017 Aabeeya. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var composeButton: UIBarButtonItem!
    
    var replyId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetText.becomeFirstResponder()
        
        if(replyId != nil) {
            composeButton.title = "Reply"
        } else {
            composeButton.title = "Tweet"
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweetButton(_ sender: Any) {
        let text = tweetText.text!;
        if (text.count > 0 && text.count <= 140) {
            TwitterClient.sharedInstance?.tweet(text: text, replyTo: self.replyId, success: {() in
                    self.dismiss(animated: true, completion: nil)
                }, failure: { (error: NSError) in
                    print (error.localizedDescription)
                }
            )
        }
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
