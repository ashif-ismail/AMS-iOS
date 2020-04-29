//
//  LoginResponse.swift
//  AMS
//
//  Created by DOT Developer DOT on 02/01/2020.
//  Copyright © 2020 Doodle. All rights reserved.
//

import Foundation

class LoginResponse: Codable {
    public let accessToken, authToken: String
    public let userType: Int
    public let tokenType, expiresAt: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case authToken = "auth_token"
        case userType = "user_type"
        case tokenType = "token_type"
        case expiresAt = "expires_at"
    }
    
    init(accessToken: String, authToken: String, userType: Int, tokenType: String, expiresAt: String) {
        self.accessToken = accessToken
        self.authToken = authToken
        self.userType = userType
        self.tokenType = tokenType
        self.expiresAt = expiresAt
    }
}
