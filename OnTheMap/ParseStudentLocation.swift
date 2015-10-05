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
}