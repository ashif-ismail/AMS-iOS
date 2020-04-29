//
//  RequestListResponse.swift
//  AMS
//
//  Created by DOT Developer DOT on 05/01/2020.
//  Copyright © 2020 Doodle. All rights reserved.
//

import Foundation

// MARK: - RequestListResponseElement
public struct RequestListResponseElement: Codable {
    let id: Int
    let subject,hierarchy,status: String
    let requestListResponseDescription, createdOn, updatedOn, firstName: String
    let lastName, designation: String
    let image: String
    let hrLast, ceoLast, chairmanLast: String?
    
    enum CodingKeys: String, CodingKey {
        case id, subject, hierarchy, status
        case requestListResponseDescription = "description"
        case createdOn = "created_on"
        case updatedOn = "updated_on"
        case firstName = "first_name"
        case lastName = "last_name"
        case designation, image
        case hrLast = "hr_last"
        case ceoLast = "ceo_last"
        case chairmanLast = "chairman_last"
    }
    
    init(id: Int, subject: String, hierarchy: String, status: String, requestListResponseDescription: String, createdOn: String, updatedOn: String, firstName: String, lastName: String, designation: String, image: String, hrLast: String, ceoLast: String, chairmanLast: String) {
        self.id = id
        self.subject = subject
        self.hierarchy = hierarchy
        self.status = status
        self.requestListResponseDescription = requestListResponseDescription
        self.createdOn = createdOn
        self.updatedOn = updatedOn
        self.firstName = firstName
        self.lastName = lastName
        self.designation = designation
        self.image = image
        self.hrLast = hrLast
        self.ceoLast = ceoLast
        self.chairmanLast = chairmanLast
    }
}

typealias RequestListResponse = [RequestListResponseElement]

// MARK: - URLSession response handlers

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
    
    func requestListResponseTask(with request: URLRequest, completionHandler: @escaping (RequestListResponse?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: request, completionHandler: completionHandler)
    }
}

