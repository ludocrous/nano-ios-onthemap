//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Derek Crous on 04/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import Foundation
import MapKit

// Class to handle Student Location Information
struct StudentLocation {
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var objectID: String?
    var uniqueKey: String?
    var latitude: Double?
    var longitude: Double?
    //Note: These dates should be converted but since the format lends itself to sorting I will leave as is
    var createdAt: String?
    var updatedAt: String?
    // Calced property to show Full Name
    var fullName: String {
        get {
            let emptyString = ""
            return "\(firstName == nil ? emptyString : firstName!) \(lastName == nil ? emptyString :  lastName!)".stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
    }
    init() {
        
    }
    
    init?(resultDict: [String:AnyObject]) {
        //Initialise properties from JSON results dictionary
        objectID = resultDict[ParseClient.JSONResponseKeys.ResultsObjectID] as? String
        uniqueKey = resultDict[ParseClient.JSONResponseKeys.ResultsUniqueKey] as? String
        firstName = resultDict[ParseClient.JSONResponseKeys.ResultsFirstName] as? String
        lastName = resultDict[ParseClient.JSONResponseKeys.ResultsLastName] as? String
        mapString = resultDict[ParseClient.JSONResponseKeys.ResultsMapString] as? String
        mediaURL = resultDict[ParseClient.JSONResponseKeys.ResultsMediaURL] as? String
        latitude = resultDict[ParseClient.JSONResponseKeys.ResultsLatitude] as? Double
        longitude = resultDict[ParseClient.JSONResponseKeys.ResultsLongitude] as? Double
        createdAt = resultDict[ParseClient.JSONResponseKeys.ResultsCreatedAt] as? String
        updatedAt = resultDict[ParseClient.JSONResponseKeys.ResultsUpdatedAt] as? String
        //Note: This is subjective and could be applied to all properties
        if objectID == nil || uniqueKey == nil || latitude == nil || longitude == nil || firstName == nil {
            return nil
        }
    }
    
// Convert location into a Map Annotation with coordinate point only
    func asMapAnnotationPointOnly () -> MKPointAnnotation {
        let lat = CLLocationDegrees(latitude!)
        let long = CLLocationDegrees(longitude!)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        return annotation
    }

// Convert location into a Map Annotation with fullname and url for map pins
    func asMapAnnotation () -> MKPointAnnotation {
        let annotation = self.asMapAnnotationPointOnly()
        annotation.title = "\(firstName!) \(lastName!)"
        annotation.subtitle = mediaURL!
        return annotation
    }
    
}


// Class (array) to hold Student locations and their map annotations
class StudentLocationCollection {
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
            collection.removeAll()
            annotations.removeAll()
        }
        for studLocDict in results {
            if let newStudLoc = StudentLocation(resultDict: studLocDict as [String:AnyObject]) {
                collection.append(newStudLoc)
            }
        }
        collection.sortInPlace {$0.createdAt > $1.createdAt}
        for loc in collection{
            annotations.append(loc.asMapAnnotation())
        }
    }

}