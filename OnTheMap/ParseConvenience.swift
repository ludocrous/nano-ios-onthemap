//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Derek Crous on 04/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import Foundation


extension ParseClient {
    
    // Request list of student locations
    func loadStudentLocations (completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        self.getStudentLocations() { (success, errorString) in
            if success {
                completionHandler(success: true, errorString: nil)
            } else {
                completionHandler(success: false,  errorString: errorString)
            }
        }
    }

    func getStudentLocations(completionHandler: (success: Bool, errorString: String?) -> Void) {
        taskForGETMethod(Methods.GetStudentLocations)  { (result, error) -> Void in
            if let error = error {
                completionHandler(success: false, errorString: error.localizedDescription)
            } else {
                if let resultsDict = (result as? [String:AnyObject]) where resultsDict.indexForKey(JSONResponseKeys.Results) != nil {
                    if let studLocArray = resultsDict[JSONResponseKeys.Results] as? [[String:AnyObject]] {
                        StudentLocationCollection.sharedInstance().populateCollectionFromResults(true, results: studLocArray)
                        print("Students Loaded: \(StudentLocationCollection.sharedInstance().collection.count)")
                        completionHandler(success: true, errorString: nil)

                    } else {
                        completionHandler(success: false, errorString: "Error unpacking student locations")
                    }
                    
                } else {
                    completionHandler(success: false, errorString: "No student location details returned")
                }
            }
        }
        
    }
    
/*
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
    
    
    
    func deleteSessionID(completionHandler: (success: Bool, errorString: String?) -> Void) {
        taskForDELETEMethod()  { (result, error) -> Void in
            if let error = error {
                completionHandler(success: false, errorString: error.localizedDescription)
            } else {
                if let sessionDict = (result as? [String:AnyObject]) where sessionDict.indexForKey("session") != nil {
                    if let sessionID = (sessionDict[JSONResponseKeys.Session] as! [String:AnyObject])["id"] {
                        print("Deleted Session Key: \(sessionID)")
                        completionHandler(success: true, errorString: nil)
                    } else {
                        print("Session dict contains no key id")
                        completionHandler(success: false, errorString: "Session dict contains no key id")
                    }
                } else {
                    completionHandler(success: false, errorString: "No user details returned")
                }
            }
        }
        
    }
*/
}


