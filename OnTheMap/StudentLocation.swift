//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Shahad on 20/03/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import Foundation

struct StudentLocation : Codable {
    
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Float
    var longitude: Float
    var createdAt : String
    var updatedAt: String
   
    enum CodingKeys: String, CodingKey {
        case objectId = "objectId"
        case uniqueKey = "uniqueKey"
        case firstName = "firstName"
        case lastName = "lastName"
        case mapString = "mapString"
        case mediaURL = "mediaURL"
        case latitude = "latitude"
        case longitude = "longitude"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        
    }
}
