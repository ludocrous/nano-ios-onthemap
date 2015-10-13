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

    @IBOutlet weak var refreshButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtonTouch(sender: UIBarButtonItem) {
        UdClient.sharedInstance().deleteSessionID() {
            (success, errorString) in
            if !success {
                displayAlertOnMainThread("Logout not successfully completed",message: "Udacity session may still be active", onViewController: self)
            }
            // Return to Login screen regardless
            dispatch_async(dispatch_get_main_queue(),{
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }

    }
    
    func refreshViews() {
        switch self.selectedIndex {
        case 0 : // The map view
            (self.selectedViewController as! MapViewController).refreshView()
        case 1: // The list view
            (self.selectedViewController as! ListViewController).refreshView()
        default:
            break
        }
      
    }

    @IBAction func refreshDataTouch(sender: AnyObject) {
        refreshButton.enabled = false
        
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
                self.refreshButton.enabled = true
            })
            if success {
                dbg("Successful refresh of data")
                dispatch_async(dispatch_get_main_queue(),{
                    self.refreshViews()
                })

            } else {
                err("Failed to refresh data")
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
