//
//  LoginRequest.swift
//  AMS
//
//  Created by DOT Developer DOT on 02/01/2020.
//  Copyright © 2020 Doodle. All rights reserved.
//

import Foundation

class LoginRequest : Encodable{
    var email: String!
    var password: String!
    var rememberMe: Bool!
    
    init(email: String,password: String,rememberMe: Bool) {
        self.email = email
        self.password = password
        self.rememberMe = rememberMe
    }
}
