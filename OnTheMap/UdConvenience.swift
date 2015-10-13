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

    //MARK: Public functions
    func authenticateWithUsername(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        self.postSessionID(username, password: password) { (success, sessionID, errorString) in
            if success {
                self.getUserData() {(success, result, errorString) in
                    if success {
                        dbg("Found details for: \(result?.key) First: \(result?.firstName) Last: \(result?.lastName)")
                        completionHandler(success: true, errorString: nil)
                    } else {
                        completionHandler(success: false,  errorString: errorString)
                    }
                }
            } else {
                completionHandler(success: false,  errorString: errorString)
            }
        }
    }
    
    //MARK: Private functions
    // Retrieve the session ID from Udacity using the POST method
    func postSessionID(username: String, password: String, completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void)  {
        
        let userPassDict: [String: AnyObject] = [JSONBodyKeys.Username:username, JSONBodyKeys.Password:password]
        let jsonBody: [String: AnyObject] = ["udacity" : userPassDict]
        taskForPOSTMethod(Methods.CreateSession, jsonBody: jsonBody) { JSONResult, error in
            
            if let error = error {
                switch error.code {
                case -1009:
                    completionHandler(success: false, sessionID: nil, errorString: "Internet connection not available")
                case -1001:
                    completionHandler(success: false, sessionID: nil, errorString: "Network connection timed out")
                case UdError.Unauthorised.rawValue:
                    completionHandler(success: false, sessionID: nil, errorString: "Invalid Username/Password")
                default:
                    completionHandler(success: false, sessionID: nil, errorString: "Unknown Error")
                }
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
                                        dbg("Successfully found session ID: \(self.sessionID)")
                                        completionHandler(success: true, sessionID: self.sessionID, errorString: nil)
                                    } else {
                                        // cannot get session ID
                                        let errorMsg = "Cannot locate ID in session results"
                                        err(errorMsg)
                                        completionHandler(success: false, sessionID: nil, errorString: errorMsg)
                                    }
                                } else {
                                    // No session Dict
                                    let errorMsg = "Cannot locate session information in results"
                                    err(errorMsg)
                                    completionHandler(success: false, sessionID: nil, errorString: errorMsg)
                                }
                            } else {
                                // No key ??
                                let errorMsg = "Cannot locate key in user results"
                                err(errorMsg)
                                completionHandler(success: false, sessionID: nil, errorString: errorMsg)
                            }
                        } else {
                            // Error because user is not registered
                            let errorMsg = "User is not registered"
                            err(errorMsg)
                            completionHandler(success: false, sessionID: nil, errorString: errorMsg)
                        }
                    } else {
                        //Error dictionary has no account entry
                        let errorMsg = "Cannot locate user registration information in account results"
                        err(errorMsg)
                        completionHandler(success: false, sessionID: nil, errorString: errorMsg)
                    }
                    
                } else {
                    //Else no account entry in response
                    let errorMsg = "Cannot locate account information in results"
                    err(errorMsg)
                    completionHandler(success: false, sessionID: nil, errorString: errorMsg)
                }
            }
        }
    }
    
    // Retrieve the Udacity information for the user.
    func getUserData(completionHandler: (success: Bool, result: UdUser?, errorString: String?) -> Void) {
        var mutableMethod : String = Methods.GetPublicUserData
        mutableMethod = UdClient.subtituteKeyInMethod(mutableMethod, key: UdClient.URLKeys.UserID, value: String(UdClient.sharedInstance().userID!))!
        taskForGETMethod(mutableMethod)  { (result, error) -> Void in
            if let error = error {
                err("Error in getUserData:\(error.localizedDescription)")
                completionHandler(success: false, result: nil, errorString: error.localizedDescription)
            } else {
                if let userDict = (result as? [String:AnyObject]) where userDict.indexForKey("user") != nil {
                    let userDetail = userDict[JSONResponseKeys.User] as! [String:AnyObject]
                    UdUser.sharedInstance().setPropertiesFromResults(userDetail)
                    dbg("Udacity User Data loaded with unique key: \(UdUser.sharedInstance().key)")
                    completionHandler(success: true, result: UdUser.sharedInstance(), errorString: nil)
                    
                } else {
                    err("Udacity User Data load failed: No user details returned")
                    completionHandler(success: false, result: nil, errorString: "No user details returned")
                }
            }
        }

    }

    // Use delete method to "delete" the session and force Udacity to delete the session ID server side
   func deleteSessionID( completionHandler: (success: Bool, errorString: String?) -> Void) {
        let method = Methods.DeleteSession
        taskForDELETEMethod(method) { (result, error) in
            if let error = error {
                err("Error in getUserData:\(error.localizedDescription)")
                completionHandler(success: false, errorString: error.localizedDescription)
            } else {
                if let resultDict = (result as? [String:AnyObject]) where resultDict.indexForKey(JSONResponseKeys.Session) != nil {
                    if let sessionDict  = resultDict[JSONResponseKeys.Session] as? [String: AnyObject] {
                        if let sessionID = sessionDict[JSONResponseKeys.SessionID] as? String {
                            dbg("Successful logout with Session ID: \(sessionID)")
                            completionHandler(success: true,  errorString: nil)
                            return
                        }
                    }
                }
                err("Udacity Session deletion (logout) failed")
                completionHandler(success: false, errorString: "Unable to delete session ID")
            }
        }
    }

    //MARK: Udacity Website sign up
    func loadUdacitySignUpPage () {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
}


