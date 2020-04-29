//
//  ProfileResponse.swift
//  AMS
//
//  Created by DOT Developer DOT on 09/01/2020.
//  Copyright © 2020 Doodle. All rights reserved.
//

import Foundation

// MARK: - ProfileResponse
class ProfileResponse: Codable {
    let firstName, lastName,email,designation: String?
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email,designation, image
    }
    
    init(firstName: String, lastName: String, email: String,designation: String?, image: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.designation = designation
        self.image = image
    }
}

extension URLSession {
    fileprivate func codableTask<T: Codable>(with request: URLRequest, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? JSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func profileResponseTask(with request: URLRequest, completionHandler: @escaping (ProfileResponse?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: request, completionHandler: completionHandler)
    }
}
