//
//  LCUtils.swift
//  OnTheMap
//
//  Created by Derek Crous on 06/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import UIKit

func displayAlert(title: String, message: String?, onViewController: UIViewController) {
    let myAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    myAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
    onViewController.presentViewController(myAlert,animated: true, completion: nil)
}

func displayAlertOnMainThread(title: String, message: String?, onViewController: UIViewController) {
    dispatch_async(dispatch_get_main_queue(),{
        displayAlert( title, message: message, onViewController: onViewController)
    })
    
}