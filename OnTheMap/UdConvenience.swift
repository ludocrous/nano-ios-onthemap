//
//  UdConvenience.swift
//  OnTheMap
//
//  Created by Derek Crous on 02/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import Foundation
import UIKit


extension UdClient {
    
    // Control the request for Udacity Login
    func authenticateWithUsername(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
    }
    
    func getSessionID(username: String, password: String, completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
        
    }
    
    func getUserData(completionHandler: (success: Bool, )
    
    
    //Mark: Udacity Website sign up
    func loadUdacitySignUpPage () {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
}


