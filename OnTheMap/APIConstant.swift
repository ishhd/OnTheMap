//
//  APIConstant.swift
//  OnTheMap
//
//  Created by Shahad on 01/04/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import Foundation


struct PostLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
}

struct PostLocationResponse: Codable {
    let createAt: String
    let objectId: String
    
    enum CodingKeys: String, CodingKey {
        case createAt
        case objectId
    }
}


struct PutLocation: Codable {
    let updatedAt: String
}

