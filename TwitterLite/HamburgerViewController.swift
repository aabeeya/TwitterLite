//
//  HamburgerViewController.swift
//  TwitterLite
//
//  Created by Bilal on 10/6/17.
//  Copyright © 2017 Aabeeya. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!        // leftmarginConstraint : contentleadingconstraint

    var originalLeftMargin : CGFloat!           // original leading
    
    // create property observer so it can put me in the view
    // whenever you set that view controller, put it in my view hierarchy
    // if i want multiple view controllers in the same view i just grab their views and put them in my view hierarchy as continer view controller

    var menuViewController : UIViewController! {
        didSet {
            view.layoutIfNeeded()  // Detail 16:54 hamburger menu
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            contentView.addSubview(contentViewController.view)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == UIGestureRecognizerState.began {
            // capture the original left margin when the gesture begins
            originalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == UIGestureRecognizerState.changed {
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        } else if sender.state == UIGestureRecognizerState.ended {
            //can't change frames in auto layout, instead change constraints
            UIView.animate(withDuration: 0.3, animations: {
                // dragging in positive x, open menu
                // dragging in negative x, closw menu
                if velocity.x > 0 {
                 // this is open
                 self.leftMarginConstraint.constant = self.view.frame.size.width - 50
                } else {
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
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
