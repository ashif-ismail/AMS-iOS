//
//  AppConstants.swift
//  AMS
//
//  Created by DOT Developer DOT on 05/01/2020.
//  Copyright © 2020 Doodle. All rights reserved.
//

import Foundation

extension UserDefaults {
    func setAccessToken(accessToken: String) {
        set(accessToken, forKey: UserDefaultKeys.ACCESS_TOKEN.rawValue)
    }
    func getAccessToken() -> String {
        return string(forKey: UserDefaultKeys.ACCESS_TOKEN.rawValue)!
    }
    
    func setUserType(userType: Int) {
        set(userType, forKey: UserDefaultKeys.USER_TYPE.rawValue)
    }
    func getUserType() -> Int {
        return integer(forKey: UserDefaultKeys.USER_TYPE.rawValue)
    }
    
    func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultKeys.IS_LOGGED_IN.rawValue)
    }
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultKeys.IS_LOGGED_IN.rawValue)
    }
}

enum UserDefaultKeys : String{
    case ACCESS_TOKEN
    case USER_TYPE
    case IS_LOGGED_IN
}
