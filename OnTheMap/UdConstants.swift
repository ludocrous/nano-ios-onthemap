//
//  UdConstants.swift
//  OnTheMap
//
//  Created by Derek Crous on 02/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import Foundation

extension UdClient {
    
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
    //TODO: Possibly unnecessary
    struct ParameterKeys {
        
    }
        
    struct JSONBodyKeys {
        static let Username = "username"
        static let Password = "password"
    }
    
    struct JSONResponseKeys {
        //MARK: Session responses
        
        //MARK: For account section
        static let Account = "account"
        static let AccountRegistered = "registered"
        static let AccountKey = "key"
        
        static let Session = "session"
        static let SessionID = "id"
        static let SessionExpiration = "expiration"
        
        //MARK: For user information 
        
        static let User = "user"
        static let UserFirstName = "first_name"
        static let UserLastName = "last_name"
        static let UserKey = "key"
        
        
    }
    
}