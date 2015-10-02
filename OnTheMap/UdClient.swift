//
//  UdClient.swift
//  OnTheMap
//
//  Created by Derek Crous on 02/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import Foundation

class UdClient : NSObject {

    var sessionID: String? = nil
    var userID: String? = nil
    

//MARK: Singleton of class
    
    class func sharedInstance() -> UdClient {
        
        struct Singleton {
            static var sharedInstance = UdClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
