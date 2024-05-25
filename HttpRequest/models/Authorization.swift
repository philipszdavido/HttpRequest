//
//  Authorization.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 25/05/2024.
//

import Foundation


//struct Authorization: Codable {
//    var type: String;
//    var auth: Basic Bearer
//}
//
//struct Basic: Codable {
//    var type: String {
//        return "Basic"
//    }
//    var username: String
//    var password: String
//}
//
//struct Bearer: Codable {
//    var type: String {
//        return "Bearer"
//    }
//    var token: String
//}
//
//struct ApiKey: Codable {
//    var type: String {
//        return "ApiKey"
//    }
//    var apiKey: String
//}

//enum AuthType: String, Codable {
//    case none
//    case inherit
//    case basic
//    case bearer
//    case oauth2
//    case apikey
//}

struct Authorization: Codable {
    var type: String;
}

struct Basic: Codable {
    var username: String
    var password: String
}

struct Bearer: Codable {
    var token: String
}

struct ApiKey: Codable {
    var apiKey: String
}
