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
    var segueApproved = false
    var userOverwriteRequested = false

    @IBOutlet weak var refreshButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dbg("Setting segue to false")
        segueApproved = false
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
    
    func requestUserOverwrite() {
        let myAlert = UIAlertController(title: "You have an existing location", message: "Overwrite ?", preferredStyle: UIAlertControllerStyle.Alert)
        myAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {(alertAction: UIAlertAction!) -> Void in
            self.userOverwriteRequested = true
            self.segueApproved = true
            self.continueSegue()})
        myAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {(alertAction: UIAlertAction!) -> Void in
            self.userOverwriteRequested = false
            self.segueApproved = false
            })
        self.presentViewController(myAlert,animated: true, completion: nil)
    }
    
    func hasUserEnteredLocation() {
        ParseClient.sharedInstance().getUserStudentLocations() { (success, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(),{
                    dbg("Asking for overwrite")
                    self.requestUserOverwrite()
                })
            } else {
               self.segueApproved = true
                dispatch_async(dispatch_get_main_queue(),{
                    dbg("Approving segue")
                    self.continueSegue()
                })
            }
        }
    
    }
    func continueSegue() {
        if segueApproved {
            performSegueWithIdentifier("EnterLocation", sender: self)
            segueApproved = false
            userOverwriteRequested = false
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
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if segueApproved {
            dbg("Performing Segue for: \(identifier)")
            return true
        } else {
            dbg("Deferring Segue for: \(identifier)")
            //Need to search for existing entry for logged in student
            hasUserEnteredLocation()
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        dbg("Calling Prepare for segue")
        (segue.destinationViewController as! StudentLocationController).studentHasExistingEntry = userOverwriteRequested
        
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
