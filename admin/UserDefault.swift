//
//  UserDefault.swift
//  admin-WKWebview
//
//  Created by godowondev on 2018. 4. 20..
//  Copyright © 2018년 design. All rights reserved.
//

import Foundation

class UserDefault{
    class func save(key:String, value:String){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(value, forKey: key)
        userDefaults.synchronize()
    }
    
    class func load(key:String) -> String {
        let userDefaults = UserDefaults.standard
        if let value = userDefaults.value(forKey: key) as? String {
            return value
        } else {
            return ""
        }
    }
    
    class func delete(key:String) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key)
    }
}
