//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Derek Crous on 04/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import Foundation

class ParseClient : NSObject {
    
    
    var session : NSURLSession
    
    var sessionID: String? = nil
    var userID: String? = nil
    var user: UdUser? = nil
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // This function builds the dataTask to GET Student Location records
    
    func taskForGETMethod(method: String,  parameters: [String: AnyObject], substituteIntoParameters: Bool = false, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        var mutableParams = parameters
        if substituteIntoParameters {
            mutableParams = ParseClient.subtituteKeyInParameters(mutableParams, key: URLKeys.UniqueKey, value: UdUser.sharedInstance().key!)
        }
        let urlString = Constants.BaseURLSecure + method + ParseClient.escapedParameters(mutableParams)
        dbg("Url: \(urlString)")
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constants.ParseKey, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
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
                    completionHandler(result: nil, error:  NSError(domain: "PaError", code: PaError.Unknown.rawValue, userInfo: nil))
                } else if let response = response {
                    err("Your request returned an invalid response! Response: \(response)!")
                    completionHandler(result: nil, error:  NSError(domain: "PaError", code: PaError.Unknown.rawValue, userInfo: nil))
                } else {
                    err("Your request returned an invalid response!")
                    completionHandler(result: nil, error:  NSError(domain: "PaError", code: PaError.Unknown.rawValue, userInfo: nil))
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                err("No data was returned by the request!")
                completionHandler(result: nil, error:  NSError(domain: "PaError", code: PaError.Unknown.rawValue, userInfo: nil))
                return
            }
            
            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        task.resume()
        return task
    }

    // This function builds the dataTask to POST the current users Student Location record
    
    func taskForPOSTMethod(method: String,  jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constants.BaseURLSecure + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(Constants.ParseKey, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
            dbg("Request Body: \(jsonBody)")
        }

        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                err("There was an error with your request: \(error)")
                completionHandler(result: nil, error:  NSError(domain: "PaError", code: PaError.Unknown.rawValue, userInfo: nil))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    err("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    completionHandler(result: nil, error:  NSError(domain: "PaError", code: PaError.Unknown.rawValue, userInfo: nil))
                } else if let response = response {
                    err("Your request returned an invalid response! Response: \(response)!")
                    completionHandler(result: nil, error:  NSError(domain: "PaError", code: PaError.Unknown.rawValue, userInfo: nil))
                } else {
                    err("Your request returned an invalid response!")
                    completionHandler(result: nil, error:  NSError(domain: "PaError", code: PaError.Unknown.rawValue, userInfo: nil))
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                err("No data was returned by the request!")
                completionHandler(result: nil, error:  NSError(domain: "PaError", code: PaError.Unknown.rawValue, userInfo: nil))
                return
            }
            
            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        task.resume()
        return task
    }

    func taskForPUTMethod(method: String,  jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constants.BaseURLSecure + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        request.addValue(Constants.ParseKey, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
            dbg("Request Body: \(jsonBody)")
        }
        
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                err("There was an error with your request: \(error)")
                completionHandler(result: nil, error:  NSError(domain: "PaError", code: PaError.Unknown.rawValue, userInfo: nil))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    err("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    completionHandler(result: nil, error:  NSError(domain: "PaError", code: PaError.Unknown.rawValue, userInfo: nil))
                } else if let response = response {
                    err("Your request returned an invalid response! Response: \(response)!")
                    completionHandler(result: nil, error:  NSError(domain: "PaError", code: PaError.Unknown.rawValue, userInfo: nil))
                } else {
                    err("Your request returned an invalid response!")
                    completionHandler(result: nil, error:  NSError(domain: "PaError", code: PaError.Unknown.rawValue, userInfo: nil))
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                err("No data was returned by the request!")
                completionHandler(result: nil, error:  NSError(domain: "PaError", code: PaError.Unknown.rawValue, userInfo: nil))
                return
            }
            
            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        task.resume()
        return task
    }
    
    // Helper function to build the jsonBody dictionary for the POST, with an all or nothing approach to property values being set
    class func buildJSONBodyFromUdUser () -> [String: AnyObject] {
        var jsonBody: [String:AnyObject] = [:]
        if let value = UdUser.sharedInstance().studentLocation.uniqueKey {
            jsonBody[JSONBodyKeys.UniqueKey] =  value
        } else {
            return [:]
        }
        if let value = UdUser.sharedInstance().studentLocation.firstName {
            jsonBody[JSONBodyKeys.FirstName] =  value
        } else {
            return [:]
        }
        if let value = UdUser.sharedInstance().studentLocation.lastName {
            jsonBody[JSONBodyKeys.LastName] =  value
        } else {
            return [:]
        }
        if let value = UdUser.sharedInstance().studentLocation.mapString {
            jsonBody[JSONBodyKeys.MapString] =  value
        } else {
            return [:]
        }
        if let value = UdUser.sharedInstance().studentLocation.mediaURL {
            jsonBody[JSONBodyKeys.MediaURL] =  value
        } else {
            return [:]
        }
        if let value = UdUser.sharedInstance().studentLocation.latitude {
            jsonBody[JSONBodyKeys.Latitude] =  value
        } else {
            return [:]
        }
        if let value = UdUser.sharedInstance().studentLocation.longitude {
            jsonBody[JSONBodyKeys.Longitude] =  value
        } else {
            return [:]
        }
        return jsonBody
    }

    
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    class func subtituteKeyInParameters(parameters: [String: AnyObject], key: String, value: String) -> [String: AnyObject] {
        var resultsDict: [String:AnyObject] = [:]
        for (dictKey,dictValue) in parameters {
            if let stringValue: String  = (dictValue as? String) {
                if stringValue.rangeOfString("{\(key)}") != nil {
                    resultsDict[dictKey] = stringValue.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
                } else {
                    resultsDict[dictKey] = dictValue
                }
                
            } else {
                resultsDict[dictKey] = dictValue
            }
        }
        return resultsDict
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
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }

    
    
    //MARK: Singleton of class
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
