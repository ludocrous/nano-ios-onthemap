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
    var id: String?
    var firstName: String?
    var lastName: String?
    
    class func createUserFromResults(dictionary: [String: AnyObject]) -> UdUser {
        let result = UdUser()
        print(dictionary)
        result.firstName = dictionary[UdClient.JSONResponseKeys.UserFirstName] as? String
        result.lastName = dictionary[UdClient.JSONResponseKeys.UserLastName] as? String
        result.id = dictionary[UdClient.JSONResponseKeys.UserID] as? String
        return result
    }
}