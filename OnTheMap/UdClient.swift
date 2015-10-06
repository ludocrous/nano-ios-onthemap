//
//  UdClient.swift
//  OnTheMap
//
//  Created by Derek Crous on 02/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import Foundation

class UdClient : NSObject {


    var session : NSURLSession
    
    var sessionID: String? = nil
    var userID: String? = nil
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    //POST Method
    func taskForPOSTMethod(method: String, jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constants.BaseURLSecure + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
            dbg("Request Body: \(jsonBody)")
        }
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                err("There was an error with your request: \(error)")
                completionHandler(result: nil, error: error)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    err("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    if response.statusCode == 403 {
                        completionHandler(result: nil, error:  NSError(domain: "UdError", code: UdError.Unauthorised.rawValue, userInfo: nil))
                    } else {
                        completionHandler(result: nil, error:  NSError(domain: "UdError", code: UdError.Unknown.rawValue, userInfo: nil))
                    }
                } else if let response = response {
                    err("Your request returned an invalid response! Response: \(response)!")
                    completionHandler(result: nil, error:  NSError(domain: "UdError", code: UdError.Unknown.rawValue, userInfo: nil))
                } else {
                    err("Your request returned an invalid response!")
                    completionHandler(result: nil, error:  NSError(domain: "UdError", code: UdError.Unknown.rawValue, userInfo: nil))
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                err("No data was returned by the request!")
                return
            }
            
            let cleanData = UdClient.stripUdacitySecurityFromData(data)
            
            UdClient.parseJSONWithCompletionHandler(cleanData, completionHandler: completionHandler)
        }
        
        task.resume()
        
        return task
    }

    
    
    func taskForGETMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let urlString = Constants.BaseURLSecure + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            // Guard for primary exception
            guard (error == nil) else {
                err("taskForGETMethod: There was an error with your request: \(error)")
                completionHandler(result: nil, error: error)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    err("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    if response.statusCode == 403 {
                        completionHandler(result: nil, error:  NSError(domain: "UdError", code: UdError.Unauthorised.rawValue, userInfo: nil))
                    } else {
                        completionHandler(result: nil, error:  NSError(domain: "UdError", code: UdError.Unknown.rawValue, userInfo: nil))
                    }
                } else if let response = response {
                    err("Your request returned an invalid response! Response: \(response)!")
                    completionHandler(result: nil, error:  NSError(domain: "UdError", code: UdError.Unknown.rawValue, userInfo: nil))
                } else {
                    err("Your request returned an invalid response!")
                    completionHandler(result: nil, error:  NSError(domain: "UdError", code: UdError.Unknown.rawValue, userInfo: nil))
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                err("No data was returned by the request!")
                completionHandler(result: nil, error:  NSError(domain: "UdError", code: UdError.Unknown.rawValue, userInfo: nil))
                return
            }
            
            let cleanData = UdClient.stripUdacitySecurityFromData(data)
            
            UdClient.parseJSONWithCompletionHandler(cleanData, completionHandler: completionHandler)
        }
        task.resume()
        return task
    }
    
   /* func taskForDELETEMethod( completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        //        var mutableParameters = parameters
        //        mutableParameters[ParameterKeys.ApiKey] = Constants.ApiKey
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + Methods.DeleteSession //+ TMDBClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        if let theCookies = sharedCookieStorage.cookies {
            for cookie in theCookies {
                if cookie.name == "XSRF-TOKEN" {
                    xsrfCookie = cookie
                }
            }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            let cleanData = UdClient.stripUdacitySecurityFromData(data)
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            UdClient.parseJSONWithCompletionHandler(cleanData, completionHandler: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    } 
*/

    

    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    class func stripUdacitySecurityFromData (data: NSData) -> NSData {
        return data.subdataWithRange(NSMakeRange(5, data.length - 5))
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }

    
//MARK: Singleton of class
    
    class func sharedInstance() -> UdClient {
        
        struct Singleton {
            static var sharedInstance = UdClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
