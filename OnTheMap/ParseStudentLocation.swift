//
//  ParseStudent.swift
//  OnTheMap
//
//  Created by Derek Crous on 04/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import Foundation
import MapKit


struct StudentLocation {
    var firstName: String?
    var lastName: String?
    var mediaURL: String?
    var objectID: String?
    var uniqueKey: String?
    var latitude: Double?
    var longitude: Double?
    var fullName: String {
        get {
            let emptyString = ""
            return "\(firstName == nil ? emptyString : firstName!) \(lastName == nil ? emptyString :  lastName!)".stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
    }
    
    init?(resultDict: [String:AnyObject]) {
        objectID = resultDict[ParseClient.JSONResponseKeys.ResultsObjectID] as? String
        uniqueKey = resultDict[ParseClient.JSONResponseKeys.ResultsUniqueKey] as? String
        firstName = resultDict[ParseClient.JSONResponseKeys.ResultsFirstName] as? String
        lastName = resultDict[ParseClient.JSONResponseKeys.ResultsLastName] as? String
        mediaURL = resultDict[ParseClient.JSONResponseKeys.ResultsMediaURL] as? String
        latitude = resultDict[ParseClient.JSONResponseKeys.ResultsLatitude] as? Double
        longitude = resultDict[ParseClient.JSONResponseKeys.ResultsLongitude] as? Double
        //Note: This is subjective and could be applied to all properties
        if objectID == nil || uniqueKey == nil || latitude == nil || longitude == nil || firstName == nil {
            return nil
        }
    }
    
    
    
    func asMapAnnotation () -> MKPointAnnotation {
        // Notice that the float values are being used to create CLLocationDegree values.
        // This is a version of the Double type.
        let lat = CLLocationDegrees(latitude!)
        let long = CLLocationDegrees(longitude!)
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(firstName!) \(lastName!)"
        annotation.subtitle = mediaURL!

        return annotation
    }
    
}



class StudentLocationCollection {
    //TODO: These class constructs need more work, with read-only properties, etc.
    var collection: [StudentLocation] = []
    var annotations: [MKPointAnnotation] = []
    
    class func sharedInstance() ->  StudentLocationCollection {
        
        struct Singleton {
            static var sharedArray = StudentLocationCollection()
        }
        return Singleton.sharedArray
    }
    
    func populateCollectionFromResults(clearFirst: Bool, results: [[String: AnyObject]])  -> Void {
        if clearFirst {
            StudentLocationCollection.sharedInstance().collection.removeAll()
            StudentLocationCollection.sharedInstance().annotations.removeAll()
        }
        for studLocDict in results {
            if let newStudLoc = StudentLocation(resultDict: studLocDict as [String:AnyObject]) {
                StudentLocationCollection.sharedInstance().collection.append(newStudLoc)
                StudentLocationCollection.sharedInstance().annotations.append(newStudLoc.asMapAnnotation())
            }
        }
        print("After load annotation count: \(StudentLocationCollection.sharedInstance().annotations.count)")
    }

    //TODO: Remove this code
    func selfPopulateForDemo() {
        populateCollectionFromResults(true, results: self.hardCodedLocationData())
    }
    
    //TODO: Remove this code
    func hardCodedLocationData() -> [[String : AnyObject]] {
        return  [
            [
                "createdAt" : "2015-02-24T22:27:14.456Z",
                "firstName" : "Jessica",
                "lastName" : "Uelmen",
                "latitude" : 28.1461248,
                "longitude" : -82.75676799999999,
                "mapString" : "Tarpon Springs, FL",
                "mediaURL" : "www.linkedin.com/in/jessicauelmen/en",
                "objectId" : "kj18GEaWD8",
                "uniqueKey" : "872458750",
                "updatedAt" : "2015-03-09T22:07:09.593Z"
            ], [
                "createdAt" : "2015-02-24T22:35:30.639Z",
                "firstName" : "Gabrielle",
                "lastName" : "Miller-Messner",
                "latitude" : 35.1740471,
                "longitude" : -79.3922539,
                "mapString" : "Southern Pines, NC",
                "mediaURL" : "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en",
                "objectId" : "8ZEuHF5uX8",
                "uniqueKey" : "2256298598",
                "updatedAt" : "2015-03-11T03:23:49.582Z"
            ], [
                "createdAt" : "2015-02-24T22:30:54.442Z",
                "firstName" : "Jason",
                "lastName" : "Schatz",
                "latitude" : 37.7617,
                "longitude" : -122.4216,
                "mapString" : "18th and Valencia, San Francisco, CA",
                "mediaURL" : "http://en.wikipedia.org/wiki/Swift_%28programming_language%29",
                "objectId" : "hiz0vOTmrL",
                "uniqueKey" : "2362758535",
                "updatedAt" : "2015-03-10T17:20:31.828Z"
            ], [
                "createdAt" : "2015-03-11T02:48:18.321Z",
                "firstName" : "Jarrod",
                "lastName" : "Parkes",
                "latitude" : 34.73037,
                "longitude" : -86.58611000000001,
                "mapString" : "Huntsville, Alabama",
                "mediaURL" : "https://linkedin.com/in/jarrodparkes",
                "objectId" : "CDHfAy8sdp",
                "uniqueKey" : "996618664",
                "updatedAt" : "2015-03-13T03:37:58.389Z"
            ], [
                "createdAt" : "2015-03-11T02:48:18.321Z",
                "firstName" : "Joe",
                "lastName" : "Soap",
                "latitude" : 51.53037,
                "longitude" : -0.58611000000001,
                "mapString" : "London, England",
                "mediaURL" : "http://www.gamespot.com",
                "objectId" : "CDHfAy8sdk",
                "uniqueKey" : "996618665",
                "updatedAt" : "2015-03-13T03:37:58.389Z"
            ]
        ]
    }
}