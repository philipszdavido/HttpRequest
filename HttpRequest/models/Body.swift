//
//  Body.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 29/05/2024.
//

import Foundation

enum BodyTypes: Codable {
    case none
    case form_data
    case x_www_form_urlencoded
    case raw
    case graphql
}

//struct Body: Codable {
//    var type: BodyTypes
//    var value: String
//}

struct FormData: Codable, Identifiable, KeyValueEnabled {
    var id = UUID()
    var key: String;
    var value: String;
    var enabled: Bool;
}

struct XWWWUrlEncoded: Codable, Identifiable, KeyValueEnabled {
    var id = UUID()
    var key: String;
    var value: String;
    var enabled: Bool;
}

struct GraphQL: Codable, Identifiable {
    var id = UUID()
    var query: String;
    var variables: String
}

struct Body: Codable {
    var none = 0
    var formData: [FormData] = []
    var xwwwUrlEncoded: [XWWWUrlEncoded] = []
    var raw = ""
    var graphql = GraphQL(query: "", variables: "")
    var selected: BodyTypes = .none
}
