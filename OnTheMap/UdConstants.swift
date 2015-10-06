//
//  UdConstants.swift
//  OnTheMap
//
//  Created by Derek Crous on 02/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import Foundation

extension UdClient {
    //Using arbitrary codes in the absence of a formalised Error Handling Structure
    enum UdError: Int {
        case Unknown = 10001
        case BadCredentials = 10002
        case Unauthorised = 10003
    }
    
    
//MARK: Constants, Methods and Keys for Udacity JSON API
    
    
    struct Constants {
        static let FacebookAPIKey: String = "365362206864879"
        
        static let BaseURLSecure: String = "https://www.udacity.com/"
    }
    
    struct Methods {
        static let CreateSession = "api/session"
        static let DeleteSession = "api/session"
        static let GetPublicUserData = "api/users/{id}"
    }
        
    struct URLKeys {
        static let UserID = "id"
    }

//MARK: Body Keys for Udacity JSON API
    
    struct JSONBodyKeys {
        static let Username = "username"
        static let Password = "password"
    }
    
//MARK: Response Keys for Udacity JSON API
    struct JSONResponseKeys {
        static let Account = "account"
        static let AccountRegistered = "registered"
        static let AccountKey = "key"
        
        static let Session = "session"
        static let SessionID = "id"
        static let SessionExpiration = "expiration"
        
        
        static let User = "user"
        static let UserFirstName = "first_name"
        static let UserLastName = "last_name"
        static let UserKey = "key"
        
        
    }
    
}