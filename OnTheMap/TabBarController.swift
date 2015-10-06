//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Derek Crous on 05/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var activityView: UIActivityIndicatorView?
    var activityBlur: UIVisualEffectView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func refreshDataTouch(sender: AnyObject) {
        let effect:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        activityBlur = UIVisualEffectView(effect: effect)
        activityBlur!.frame = self.view.bounds;
        self.view.addSubview(activityBlur!)
        
        activityView  = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView?.center = self.view.center
        activityView?.color = UIColor.blackColor()
        activityView?.startAnimating()
        self.view.addSubview(activityView!)
        
        ParseClient.sharedInstance().loadStudentLocations() { (success, errorString ) in
            dispatch_async(dispatch_get_main_queue(),{
                self.activityView?.stopAnimating()
                self.activityView?.removeFromSuperview()
                self.activityBlur?.removeFromSuperview()
            })
            if success {
                print("Successful refresh of data")
            } else {
                print("Failed to refresh data")
                displayAlertOnMainThread("Unable to refresh data", message: nil, onViewController: self)
            }
        }

    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
