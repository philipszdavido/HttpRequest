//
//  Request.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 25/05/2024.
//

import Foundation

struct Parameter: Codable {
    let key: String;
    let value: String;
}

struct Header: Codable {
    let key: String;
    let value: String;
}

struct Variable: Codable {
    let key: String;
    let value: String;
}

//AuthorizationTypes {
//    
//}

struct Authorization: Codable {
    let type: String
}

struct Request: Identifiable, Codable {
    var id = UUID()
    let method: String;
    let url: String;
    let parameters: Array<Parameter>;
    let body: String;
    let headers: Array<Header>
    let authorization: Authorization;
    let tests: String;
    let variables: Array<Variable>;
    
    init(method: String, url: String, parameters: Array<Parameter>, body: String, headers: Array<Header>, authorization: Authorization, tests: String, variables: Array<Variable>) {
        self.method = method
        self.url = url
        self.parameters = parameters
        self.body = body
        self.headers = headers
        self.authorization = authorization
        self.tests = tests
        self.variables = variables
    }
}
