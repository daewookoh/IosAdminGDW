//
//  CheckInternetConnection.swift
//  admin
//
//  Created by design on 2015. 9. 27..
//  Copyright (c) 2015년 design. All rights reserved.
//

import Foundation

public class CheckInternetConnection {
    
    class func isConnectedToNetwork()->Bool{

        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        _ = (try? NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
}