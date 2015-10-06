//
//  UdUser.swift
//  OnTheMap
//
//  Created by Derek Crous on 02/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import Foundation

// Class implementation for Udacity User.
class UdUser {
    var key: String? {
        willSet(newKey)
        {
            studentLocation.uniqueKey = newKey
        }
    }
    var firstName: String? {
        willSet(newFirstName)
        {
            studentLocation.firstName = newFirstName
        }
    }
    var lastName: String? {
        willSet(newLastName)
        {
            studentLocation.lastName = newLastName
        }
    }
    var studentLocation: StudentLocation {
        didSet {
            studentLocation.firstName = self.firstName
            studentLocation.lastName = self.lastName
            studentLocation.uniqueKey = self.key
        }
    }
    
    init () {
        studentLocation = StudentLocation()
    }
    
    func resetLocation() {
        studentLocation = StudentLocation()
    }
    
    func setPropertiesFromResults(dictionary: [String: AnyObject]) {
        self.firstName = dictionary[UdClient.JSONResponseKeys.UserFirstName] as? String
        self.lastName = dictionary[UdClient.JSONResponseKeys.UserLastName] as? String
        self.key = dictionary[UdClient.JSONResponseKeys.UserKey] as? String
    }
    
    
    class func sharedInstance() -> UdUser {
        
        struct Singleton {
            static var sharedInstance = UdUser()
        }
        
        return Singleton.sharedInstance
    }

}