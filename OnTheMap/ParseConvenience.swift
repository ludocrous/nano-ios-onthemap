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

    func getUserStudentLocations(completionHandler: (success: Bool, errorString: String?) -> Void) {
        let parameters = [ParameterKeys.WhereQuery : "{\"uniqueKey\":\"{uniqueKey}\"} "]
        let method : String = Methods.GetUserStudentLocation

        taskForGETMethod(method, parameters: parameters, substituteIntoParameters: true)  { (result, error) -> Void in
            if let error = error {
                completionHandler(success: false, errorString: error.localizedDescription)
            } else {
                if let resultsDict = (result as? [String:AnyObject]) where resultsDict.indexForKey(JSONResponseKeys.Results) != nil {
                    dbg("Results: \(resultsDict)")
                    if let studLocArray = (resultsDict[JSONResponseKeys.Results] as? [[String:AnyObject]]) where studLocArray.count > 0 {
                        // Taking entry 0 as current entry as this will be most common,  but could take final element in array if mutiple entries returned
                        if let studentDict:[String:AnyObject] = studLocArray[0] {
                            if let objectID: String = studentDict[JSONResponseKeys.ObjectId] as? String {
                                UdUser.sharedInstance().parseObjectId = objectID
                                dbg("User objectid set to: \(objectID)")
                                completionHandler(success: true, errorString: nil)
                            } else {
                                completionHandler(success: false, errorString: "No objectId found")
                            }
                        } else {
                            completionHandler(success: false, errorString: "No student records found")
                        }
                        
                    } else {
                        completionHandler(success: false, errorString: "Error unpacking student location from query")
                    }
                    
                } else {
                    completionHandler(success: false, errorString: "No student location details returned")
                }
            }
        }
        
    }
    
//This function is used to post a new entry for the logged student location
    func postStudentLocation(completionHandler: (success: Bool, errorString: String?) -> Void) {
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

    //This function is used to update an existing entry for the logged student location
    func putStudentLocation(completionHandler: (success: Bool, errorString: String?) -> Void) {
        var mutableMethod : String = Methods.PutUserStudentLocation
        mutableMethod = UdClient.subtituteKeyInMethod(mutableMethod, key: ParseClient.URLKeys.ObjectId, value: String(UdUser.sharedInstance().parseObjectId!))!
        let jsonBody: [String: AnyObject] = ParseClient.buildJSONBodyFromUdUser()
        taskForPUTMethod(mutableMethod,jsonBody: jsonBody)  { (result, error) -> Void in
            if let error = error {
                completionHandler(success: false, errorString: "Student Location PUT failed with: \(error.localizedDescription)")
            } else {
                if let resultsDict = (result as? [String:AnyObject]) {
                    if let updatedAt = resultsDict[JSONResponseKeys.ResultsUpdatedAt] as? String{
                        dbg("User location updated as at: \(updatedAt)")
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


