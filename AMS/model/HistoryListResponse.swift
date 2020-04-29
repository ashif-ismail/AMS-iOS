//
//  HistoryListResponse.swift
//  AMS
//
//  Created by DOT Developer DOT on 08/01/2020.
//  Copyright © 2020 Doodle. All rights reserved.
//
import Foundation

// MARK: - HistoryListResponse
class HistoryListResponse: Codable {
    let currentPage: Int
    let data: [RequestListResponseElement]
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
    }
    
    init(currentPage: Int, data: [RequestListResponseElement]) {
        self.currentPage = currentPage
        self.data = data
    }
}

class HistoryData: Codable {
    let id: Int
    let subject,hierarchy,status: String
    let datumDescription, createdOn, updatedOn, firstName: String
    let lastName, designation: String
    let image: String
    let hrLast, ceoLast, chairmanLast: String?
    
    enum CodingKeys: String, CodingKey {
        case id, subject, hierarchy, status
        case datumDescription = "description"
        case createdOn = "created_on"
        case updatedOn = "updated_on"
        case firstName = "first_name"
        case lastName = "last_name"
        case designation, image
        case hrLast = "hr_last"
        case ceoLast = "ceo_last"
        case chairmanLast = "chairman_last"
    }
    
    init(id: Int, subject: String, hierarchy: String, status: String, datumDescription: String, createdOn: String, updatedOn: String, firstName: String, lastName: String, designation: String, image: String, hrLast: String, ceoLast: String, chairmanLast: String) {
        self.id = id
        self.subject = subject
        self.hierarchy = hierarchy
        self.status = status
        self.datumDescription = datumDescription
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
