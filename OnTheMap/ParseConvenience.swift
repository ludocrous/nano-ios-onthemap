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
            //TODO: Remove this code - Testing activityviews
//            NSThread.sleepForTimeInterval(NSTimeInterval(3))
                if success {
                completionHandler(success: true, errorString: nil)
            } else {
                //Intentionally not raising an error as User not able to react
                completionHandler(success: false,  errorString: errorString)
            }
        }
    }

    func getStudentLocations(completionHandler: (success: Bool, errorString: String?) -> Void) {
        let parameters = [ParameterKeys.SortOrder: "-updatedAt"]
        taskForGETMethod(Methods.GetStudentLocations, parameters: parameters)  { (result, error) -> Void in
            if let error = error {
                completionHandler(success: false, errorString: error.localizedDescription)
            } else {
                if let resultsDict = (result as? [String:AnyObject]) where resultsDict.indexForKey(JSONResponseKeys.Results) != nil {
                    if let studLocArray = resultsDict[JSONResponseKeys.Results] as? [[String:AnyObject]] {
                        StudentLocationCollection.sharedInstance().populateCollectionFromResults(true, results: studLocArray)
                        dbg("Students Loaded: \(StudentLocationCollection.sharedInstance().collection.count)")
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

    func postStudentLocation(completionHandler: (success: Bool, errorString: String?) -> Void) {
        //TODO: Should look at passing this rather than using singleton value ?
        let jsonBody: [String: AnyObject] = ParseClient.buildJSONBodyFromUdUser()
        taskForPOSTMethod(Methods.PostStudentLocation,jsonBody: jsonBody)  { (result, error) -> Void in
            if let error = error {
                completionHandler(success: false, errorString: "Student Location POST failed with: \(error.localizedDescription)")
            } else {
                if let resultsDict = (result as? [String:AnyObject]) {
                    if let objectid = resultsDict[JSONResponseKeys.ObjectId] as? String{
                        UdUser.sharedInstance().studentLocation.objectID = objectid
                        completionHandler(success: true, errorString: nil)
                        
                    } else {
                        completionHandler(success: false, errorString: "Error unpacking Student Location POST response")
                    }
                    
                } else {
                    completionHandler(success: false, errorString: "Student Location Post failed")
                }
            }
        }
        
    }

}


