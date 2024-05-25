//
//  Response.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 25/05/2024.
//

import Foundation

class Response: ObservableObject {
    @Published
    var data: Data?
    @Published
    var response: HTTPURLResponse?;
    @Published
    var error: Error?
    
    init(data: Data? = nil, response: HTTPURLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.response = response
        self.error = error
    }
        
    func statusCode() -> Int {
        if let statusCode = self.response?.statusCode {
            return statusCode
        } else {
            return 0
        }
    }
    
    func getHeaders() -> [AnyHashable : Any] {
        if let headers = self.response?.allHeaderFields {
            return headers
        } else {
            return [:]
        }
    }
    
    func errorDesc() -> String {
        
        if let _error = self.error?.localizedDescription {
            return _error;
        } else {
            return ""
        }
        
    }
    
    func getData() -> String {
        if let data = self.data {
            if let encodedString = String(data: data, encoding: .utf8) {
                return encodedString
            }
            
            return ""

        } else {
            return ""
        }
    }
}

