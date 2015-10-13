//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Derek Crous on 04/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import Foundation

extension ParseClient {
    
    enum PaError : Int {
        case Unknown = 50001
    }
    
    struct Constants {
        static let ParseKey: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let BaseURLSecure: String = "https://api.parse.com/1/"
    }
    
    struct Methods {
        static let GetStudentLocations = "classes/StudentLocation"
        static let PostStudentLocation = "classes/StudentLocation"
    }
    
    struct URLKeys {
        static let UserID = "objectid"
    }
    
    struct ParameterKeys {
        static let SortOrder = "order"
    }
    
    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    struct JSONResponseKeys {
        //MARK: Session responses
        
        
        static let Results = "results"
        static let ResultsCreatedAt = "createdAt"
        static let ResultsFirstName = "firstName"
        static let ResultsLastName = "lastName"
        static let ResultsLatitude = "latitude"
        static let ResultsLongitude = "longitude"
        static let ResultsMapString = "mapString"
        static let ResultsMediaURL = "mediaURL"
        static let ResultsObjectID = "objectId"
        static let ResultsUniqueKey = "uniqueKey"
        static let ResultsUpdatedAt = "updatedAt"
        
        //MARK: For posting student location
        static let CreatedAt = "createdAt"
        static let ObjectId = "objectId"
    }
}
