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
        
        self.postSessionID(username, password: password) { (success, sessionID, errorString) in
            if success {
                completionHandler(success: true, errorString: nil)
            } else {
                completionHandler(success: false,  errorString: errorString)
            }
        }
        
    }

    func postSessionID(username: String, password: String, completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void)  {
        
        let userPassDict: [String: AnyObject] = [JSONBodyKeys.Username:username, JSONBodyKeys.Password:password]
        let jsonBody: [String: AnyObject] = ["udacity" : userPassDict]
        taskForPOSTMethod(Methods.CreateSession, /*parameters: nil,*/ jsonBody: jsonBody) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(success: false, sessionID: nil, errorString: error.localizedDescription)
            } else {
                if let accountDict = (JSONResult as! [String:AnyObject])[JSONResponseKeys.Account] {
                    if let isRegistered: Bool = accountDict[JSONResponseKeys.AccountRegistered] as? Bool {
                        if isRegistered {
                            // extract the UserID and sessionID
                            if let userKey = accountDict[JSONResponseKeys.AccountKey] {
                                if let sessionDict = (JSONResult as! [String:AnyObject])[JSONResponseKeys.Session] {
                                    if let sessionID = sessionDict[JSONResponseKeys.SessionID] {
                                        self.userID = (userKey as! String)
                                        self.sessionID = (sessionID as! String)
                                        print("Successfully found session ID: \(self.sessionID)")
                                        completionHandler(success: true, sessionID: self.sessionID, errorString: nil)
                                    } else {
                                        // cannot get session ID
                                        let errorMsg = "Cannot locate ID in session results"
                                        print(errorMsg)
                                        completionHandler(success: false, sessionID: nil, errorString: errorMsg)
                                    }
                                } else {
                                    // No session Dict
                                    let errorMsg = "Cannot locate session information in results"
                                    print(errorMsg)
                                    completionHandler(success: false, sessionID: nil, errorString: errorMsg)
                                }
                            } else {
                                // No key ??
                                let errorMsg = "Cannot locate key in user results"
                                print(errorMsg)
                                completionHandler(success: false, sessionID: nil, errorString: errorMsg)
                            }
                        } else {
                            // Error because user is not registered
                            let errorMsg = "User is not registered"
                            print(errorMsg)
                            completionHandler(success: false, sessionID: nil, errorString: errorMsg)
                        }
                    } else {
                        //Error dictionary has no account entry
                        let errorMsg = "Cannot locate user registration information in account results"
                        print(errorMsg)
                        completionHandler(success: false, sessionID: nil, errorString: errorMsg)
                    }
                    
                } else {
                    //Else no account entry in response
                    let errorMsg = "Cannot locate account information in results"
                    print(errorMsg)
                    completionHandler(success: false, sessionID: nil, errorString: errorMsg)
                }
            }
        }
    }
/*
                    completionHandler(result: results, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "postToFavoritesList parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToFavoritesList"]))
                }
            }
*/
    
    
//    func getUserData(completionHandler: (success: Bool, )
    
    
    //Mark: Udacity Website sign up
    func loadUdacitySignUpPage () {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
}


