//
//  HttpService.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 24/05/2024.
//

import Foundation

class HttpService {
    func makeRequest(request: Request, completionHandler: @escaping((data: Data?, response: URLResponse?, error: Error?, timeInterval: TimeInterval)) -> Void) {

        let startTime = Date()

        guard let baseURL = URL(string: request.url) else {
            return;
        }
        
        // Create the URL components object to append the parameters
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        
        // Add the parameters as query items
        if !request.parameters.isEmpty {
            self.processParams(urlComponents: &urlComponents, parameters: request.parameters)
        }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        
        urlRequest.httpMethod = request.method
        
        if request.body.selected != .none {
            self.processBody(body: request.body, urlRequest: &urlRequest)
        }
        
        if request.authorization.selected != .none {
            self.processAuth(auth: request.authorization, urlRequest: &urlRequest)
        }
                
        if !request.headers.isEmpty {
            self.processHeaders(headers: request.headers, urlRequest: &urlRequest)
        }
        
        print(urlRequest)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in

            let endTime = Date()

            let elapsedTime = endTime.timeIntervalSince(startTime)

            completionHandler((data, response, error, elapsedTime))
            
        }.resume()

    }
    
    func processBody(body: Body, urlRequest: inout URLRequest) {
        
        switch body.selected {
        case .none:
            return;

        case .form_data:
            
            let bodyHttpService = BodyFormDataHttpService(value: body.formData)
            let postData = bodyHttpService.process()
            
            let boundary = bodyHttpService.getBoundary()
                        
            urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            // urlRequest.httpMethod = "POST"
            urlRequest.httpBody = postData
            
            return;
                        
        case .x_www_form_urlencoded:
            let xWWWFormUrlEncoded = BodyXWWUrlEncoded(value: body.xwwwUrlEncoded)
            let postData = xWWWFormUrlEncoded.process()

            urlRequest.timeoutInterval = Double.infinity
            urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = postData

            return;
            
        case .raw:
            let raw = RawHttpService(value: body.raw)
            let postData = raw.process()
            
            urlRequest.timeoutInterval = Double.infinity
            urlRequest.addValue("application/javascript", forHTTPHeaderField: "Content-Type")

            // urlRequest.httpMethod = "POST"
            urlRequest.httpBody = postData
            
            return;

        case .graphql:
            let graphql = GraphQLHttpService(query: body.graphql.query, variables: body.graphql.variables)
            let postData = graphql.process()

            urlRequest.timeoutInterval = Double.infinity
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = postData

            return;
        }

    }
    
    func processAuth(auth: Authorization, urlRequest: inout URLRequest) {
        switch auth.selected {
        case .none:
            return;
        case .inherit:
            // TODO: Implement inherit
            return;
        case .basic:
            
            let usernamePassword = auth.basic.username + ":" + auth.basic.password
            
            // Convert the string to Data
            if let data = usernamePassword.data(using: .utf8) {
                // Encode the data to Base64
                let base64EncodedString =  "Basic " + data.base64EncodedString()
                
                urlRequest.timeoutInterval = Double.infinity
                urlRequest.addValue(base64EncodedString, forHTTPHeaderField: "Authorization")
                
                print("Base64 Encoded String: \(base64EncodedString)")
            } else {
                print("Failed to convert string to Data")
            }
            return;
            
        case .bearer:
            
            urlRequest.timeoutInterval = Double.infinity
            urlRequest.addValue("Bearer " + auth.bearer.token, forHTTPHeaderField: "Authorization")
            return;
        case .oauth2:
            // TODO: Implement
            return;
            
        case .apikey:
            
            if auth.apikey.addTo == .header {
                
                urlRequest.timeoutInterval = Double.infinity
                urlRequest.addValue(auth.apikey.value, forHTTPHeaderField: auth.apikey.key)
                
            } else if auth.apikey.addTo == .query_param {
                
                urlRequest.timeoutInterval = Double.infinity
                
                // Create the URL components object to append the parameters
                if var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: true) {
                    
                    // Existing query items (if any)
                    var queryItems = urlComponents.queryItems ?? []
                    
                    // Append new query item
                    queryItems.append(URLQueryItem(name: auth.apikey.key, value: auth.apikey.value))
                    
                    // Update the URL components with the combined query items
                    urlComponents.queryItems = queryItems
                    
                    // Set the updated URL back to the URLRequest
                    urlRequest.url = urlComponents.url
                }
                
            }
            
            return;
            
        }
    }
    
    func processParams(urlComponents: inout URLComponents, parameters: [Parameter]) {
        
        urlComponents.queryItems = parameters.filter{ parameter in
            parameter.enabled
        }.map { URLQueryItem(name: $0.key, value: $0.value) }

    }
    
    func processHeaders(headers: [Header], urlRequest: inout URLRequest) {
        
        headers.forEach { header in
            urlRequest.addValue(header.key, forHTTPHeaderField: header.value)
        }

    }
}

protocol ProcessHttpService {
    // var value: Any { get set };
    func process() -> Data
}

class BodyFormDataHttpService: ProcessHttpService {
    
    var value: [FormData]
    private var boundary = UUID().uuidString
    
    init(value: [FormData]) {
        self.value = value
    }
    
    func getBoundary() -> String {
        return self.boundary
    }
    
    func process() -> Data {
        
//        let parameters = [
//          [
//            "key": "jhj",
//            "value": "hhj",
//            "type": "text"
//          ],
//          [
//            "key": "hello",
//            "value": "123",
//            "type": "text"
//          ]] as [[String: Any]]
        
        let parameters = self.value.filter{ formData in
            formData.enabled
        }.map { formData in
            
            var param = [
                "key": formData.key,
                "value": formData.value,
                "type": "text"
            ]
            
            return param
            
        } as [[String: Any]]

        let boundary = "Boundary-\(self.boundary)"
        var body = Data()
        
        var _: Error? = nil

        for param in parameters {
            
          if param["disabled"] != nil { continue }
          let paramName = param["key"]!
            
          body += Data("--\(boundary)\r\n".utf8)
          body += Data("Content-Disposition:form-data; name=\"\(paramName)\"".utf8)
          if param["contentType"] != nil {
            body += Data("\r\nContent-Type: \(param["contentType"] as! String)".utf8)
          }
          let paramType = param["type"] as! String
          if paramType == "text" {
            let paramValue = param["value"] as! String
            body += Data("\r\n\r\n\(paramValue)\r\n".utf8)
          } else {
            let paramSrc = param["src"] as! String
            let fileURL = URL(fileURLWithPath: paramSrc)
            if let fileContent = try? Data(contentsOf: fileURL) {
              body += Data("; filename=\"\(paramSrc)\"\r\n".utf8)
              body += Data("Content-Type: \"content-type header\"\r\n".utf8)
              body += Data("\r\n".utf8)
              body += fileContent
              body += Data("\r\n".utf8)
            }
          }
        }
        
        body += Data("--\(boundary)--\r\n".utf8);
        let postData = body
        
        return postData
    }
}

class BodyXWWUrlEncoded: ProcessHttpService {
    
    var value: [XWWWUrlEncoded]
    
    init(value: [XWWWUrlEncoded]) {
        self.value = value
    }
    
    func process() -> Data {
        // let parameters = "fv=fvfv&jhjb=787"
        let parameters = self.value.filter{ XWWWUrlEncoded in
            XWWWUrlEncoded.enabled
        }.map { XWWWUrlEncoded in
            return XWWWUrlEncoded.key + "=" + XWWWUrlEncoded.value
        }.joined(separator: "&")
        
        let postData =  parameters.data(using: .utf8)
        
        return postData!

    }

}

class RawHttpService: ProcessHttpService {
    
    var value: String;
    
    init(value: String) {
        self.value = value
    }
    
    func process() -> Data {
        let parameters = self.value //"jhbjhbjh"
        let postData = parameters.data(using: .utf8)
        return postData!

    }
}

class GraphQLHttpService: ProcessHttpService {
    
    var query: String;
    var variables: String;
    
    init(query: String, variables: String) {
        self.query = query
        self.variables = variables
    }
    
    func process() -> Data {
        
        var query = "query: {" + self.query + "},";
        var variables = "variables: {" + self.variables + "}"
        
        var parameter = "{" + query + variables + "}";
        let postData = parameter.data(using: .utf8)
        
        return postData!

    }
}
