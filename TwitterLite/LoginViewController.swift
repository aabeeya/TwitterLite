//
//  LoginViewController.swift
//  TwitterLite
//
//  Created by Aabeeya on 9/26/17.
//  Copyright © 2017 Aabeeya. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {

        TwitterClient.sharedInstance?.login(success: {
            // logged in now so segue to the new view controller
            // don't segue on the login button, because if yu do that, it will go to next view immediately.
            // Instead wait until success, so segue from login view controller
            print("I've logged in!")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }, failure: { (error: NSError) in
            print("Error: \(error.localizedDescription)")
        })


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
