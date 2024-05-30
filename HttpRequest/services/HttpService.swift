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
            urlComponents.queryItems = request.parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        
        urlRequest.httpMethod = request.method
        
        if request.body.selected != .none {
            //urlRequest.httpBody = request.body.data(using: .utf8)
            urlRequest = self.processBody(body: request.body, urlRequest: &urlRequest)
        }
        
        if !request.headers.isEmpty {
            request.headers.forEach { header in
                urlRequest.addValue(header.key, forHTTPHeaderField: header.value)
            }
        }
        
        print(request)
        
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
                        
            urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            urlRequest.httpMethod = "POST"
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
            <#code#>
        case .graphql:
            <#code#>
        }

    }
    
    func processAuth() {}
    func processParams() {}
    func processHeaders() {}
}

protocol ProcessHttpService {
    // var value: Any { get set };
    func process() -> Data
}

class BodyFormDataHttpService: ProcessHttpService {
    
    var value: [FormData]
    
    init(value: [FormData]) {
        self.value = value
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

        let boundary = "Boundary-\(UUID().uuidString)"
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
