//
//  MenuViewController.swift
//  TwitterLite
//
//  Created by Bilal on 10/6/17.
//  Copyright © 2017 Aabeeya. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var menuTableView: UITableView!
    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuTableView.dataSource = self
        menuTableView.delegate =  self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let composeNavigationController = storyboard.instantiateViewController(withIdentifier: "ComposeNavigationController")
        let homeNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        let profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        let profileViewController = profileNavigationController.childViewControllers[0] as! ProfileViewController
        profileViewController.user = User.currentUser;
        let mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        
        
        viewControllers.append(homeNavigationController)
        viewControllers.append(profileNavigationController)
        viewControllers.append(mentionsNavigationController)
        
        hamburgerViewController.contentViewController = homeNavigationController
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        let titles = ["Home", "Profile", "Mentions" ]
        cell.menuItemLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        
        
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
