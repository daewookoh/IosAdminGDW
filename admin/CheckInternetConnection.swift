//
//  CheckInternetConnection.swift
//  admin
//
//  Created by design on 2015. 9. 27..
//  Copyright (c) 2015년 design. All rights reserved.
//

import Foundation

open class CheckInternetConnection {
    
    class func isConnectedToNetwork()->Bool{

        var Status:Bool = false
        let url = URL(string: "http://google.com/")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: URLResponse?
        
        _ = (try? NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)) as Data?
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
}
