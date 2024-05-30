//
//  Request.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 25/05/2024.
//

import Foundation

protocol KeyValueEnabled: Codable, Identifiable {
    var id: UUID { get set }
    var key: String { get set }
    var value: String { get set }
    var enabled: Bool { get set }
}

struct Parameter: Codable, Identifiable, KeyValueEnabled {
    var id = UUID()
    var key: String;
    var value: String;
    var enabled: Bool;
}

struct Header: Codable, Identifiable, KeyValueEnabled {
    var id = UUID()
    var key: String;
    var value: String;
    var enabled: Bool;
}

struct Variable: Codable {
    var key: String;
    var value: String;
}

struct Request: Identifiable, Codable {
    var id = UUID()
    var method: String;
    var url: String;
    var parameters: [Parameter];
    var body = Body();
    var headers: [Header]
    var tests: String;
    var variables: Array<Variable>;

    var authorization = Authorization();

    var urlProtocol: String;
    
    mutating func appendAutoGeneratedHeaders() {
        self.headers += autoGeneratedHeaders
    }
    
    init(method: String, url: String, parameters: [Parameter], body: Body, headers: [Header], tests: String, variables: Array<Variable>,  authorization: Authorization, urlProtocol: String) {
        self.method = method
        self.urlProtocol = urlProtocol
        self.url = url
        self.parameters = parameters
        self.body = body
        self.headers = headers
        self.authorization = authorization
        self.tests = tests
        self.variables = variables
        
        self.appendAutoGeneratedHeaders()
    }
    
    init(parameters: [Parameter]) {
        self.parameters = parameters
        self.method = ""
        self.urlProtocol = ""
        self.url = ""
        self.body = Body()
        self.headers = []
        self.tests = ""
        self.variables = []
        self.authorization = Authorization()
        
        self.appendAutoGeneratedHeaders()

    }
    
    init() {
        self.method = ""
        self.urlProtocol = ""
        self.url = ""
        self.parameters = []
        self.body = Body()
        self.headers = []
        self.authorization = Authorization()
        self.tests = ""
        self.variables = []

        self.appendAutoGeneratedHeaders()

    }
}


var autoGeneratedHeaders = [
    Header(key: "Content-Type", value: "application/json", enabled: true),
    Header(key: "User-Agent", value: "HttpRequest Runtime", enabled: true),
    Header(key: "Accpet-Encoding", value: "gzip, deflate, br", enabled: true),
    Header(key: "Connection", value: "keep-alive", enabled: true)
]
