//
//  ParseStudent.swift
//  OnTheMap
//
//  Created by Derek Crous on 04/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import Foundation


struct StudentLocation {
    var firstName: String?
    var lastName: String?
    var mediaURL: String?
    var objectID: String?
    var uniqueKey: String?
    var latitude: Double?
    var longitude: Double?
    
    init?(resultDict: [String:AnyObject]) {
        objectID = resultDict[ParseClient.JSONResponseKeys.ResultsObjectID] as? String
        uniqueKey = resultDict[ParseClient.JSONResponseKeys.ResultsUniqueKey] as? String
        //Note: This is subjective and could be applied to all properties
        if objectID == nil || uniqueKey == nil {
            return nil
        }
        firstName = resultDict[ParseClient.JSONResponseKeys.ResultsFirstName] as? String
        lastName = resultDict[ParseClient.JSONResponseKeys.ResultsLastName] as? String
        mediaURL = resultDict[ParseClient.JSONResponseKeys.ResultsMediaURL] as? String
        latitude = resultDict[ParseClient.JSONResponseKeys.ResultsLatitude] as? Double
        longitude = resultDict[ParseClient.JSONResponseKeys.ResultsLongitude] as? Double
    }
}

class StudentLocationCollection {
    var collection: [StudentLocation] = []
    
    class func sharedInstance() ->  StudentLocationCollection {
        
        struct Singleton {
            static var sharedArray = StudentLocationCollection()
        }
        return Singleton.sharedArray
    }
    
    class func populateCollectionFromResults(clearFirst: Bool, results: [[String: AnyObject]])  -> Void {
        if clearFirst {
            StudentLocationCollection.sharedInstance().collection.removeAll()
        }
        for studLocDict in results {
            if let newStudLoc = StudentLocation(resultDict: studLocDict as [String:AnyObject]) {
                StudentLocationCollection.sharedInstance().collection.append(newStudLoc)
            }
        }
    }
}