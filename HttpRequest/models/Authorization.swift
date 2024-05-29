//
//  Authorization.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 25/05/2024.
//

import Foundation

enum AuthType: Codable {
    case none
    case inherit
    case basic
    case bearer
    case oauth2
    case apikey
}

struct Authorization: Codable {
    var selected: AuthType = .none;
    var none = 0
    var inherit = false;
    var basic = Basic(username: "", password: "")
    var bearer = Bearer(token: "")
    var oauth2 = ""
    var apikey = ApiKey(key: "", value: "", addTo: .query_param)
}

struct Basic: Codable {
    var username: String
    var password: String
}

struct Bearer: Codable {
    var token: String
}

enum ApiKeyEnum: Codable {
    case header
    case query_param
}

struct ApiKey: Codable {
    var key: String
    var value: String;
    var addTo: ApiKeyEnum
}
