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
        
    
    
}