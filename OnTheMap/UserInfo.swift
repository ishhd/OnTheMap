//
//  UserInfo.swift
//  OnTheMap
//
//  Created by Shahad on 01/04/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import Foundation

struct UserInfo : Codable{
    
    let firstName: String
    let lastName: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
}

    struct StudentsLocation: Codable {
        
        let results: [StudentLocation]
        
        enum CodingKeys: String, CodingKey {
            case results
        }
    }
    
    class SLocationData {
        
        static var studentsData = [StudentLocation]()
        
    }


struct UserLoginResponse: Codable {
    
    let account: Account
    let session: Session
    
    enum CodingKeys: String, CodingKey { case account, session }
}

struct Account: Codable {
    let registered: Bool
    let key: String
    
    enum CodingKeys: String, CodingKey { case registered, key }
}

struct Session: Codable {
    let id: String
    let expiration: String
    
    enum CodingKeys: String, CodingKey { case id, expiration }
}


