//
//  Request.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 25/05/2024.
//

import Foundation

struct Parameter: Codable, Identifiable {
    var id = UUID()
    var key: String;
    var value: String;
    var enabled: Bool;
}

struct Header: Codable {
    var key: String;
    var value: String;
}

struct Variable: Codable {
    var key: String;
    var value: String;
}

struct Request: Identifiable, Codable {
    var id = UUID()
    var method: String;
    //var urlProtocol: String;
    var url: String;
    var parameters: [Parameter];
    var body: String;
    var headers: Array<Header>
    //var authorization: Authorization;
    var tests: String;
    var variables: Array<Variable>;
    
    init(method: String, urlProtocol: String, url: String, parameters: [Parameter], body: String, headers: Array<Header>, authorization: Authorization, tests: String, variables: Array<Variable>) {
        self.method = method
        //self.urlProtocol = urlProtocol
        self.url = url
        self.parameters = parameters
        self.body = body
        self.headers = headers
        //self.authorization = authorization
        self.tests = tests
        self.variables = variables
    }
    
    init(parameters: [Parameter]) {
        self.parameters = parameters
        self.method = ""
        //self.urlProtocol = ""
        self.url = ""
        self.body = ""
        self.headers = []
        self.tests = ""
        self.variables = []
    }
    
    init() {
        self.method = ""
        //self.urlProtocol = ""
        self.url = ""
        self.parameters = []
        self.body = ""
        self.headers = []
        //self.authorization = authorization
        self.tests = ""
        self.variables = []
    }
}
