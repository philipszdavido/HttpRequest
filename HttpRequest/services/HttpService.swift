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
        
        if !request.body.isEmpty {
            urlRequest.httpBody = request.body.data(using: .utf8)
        }
        
        if !request.headers.isEmpty {
            request.headers.forEach { header in
                urlRequest.addValue(header.key, forHTTPHeaderField: header.value)
            }
        }
        
        // print(request)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in

            let endTime = Date()

            let elapsedTime = endTime.timeIntervalSince(startTime)

            completionHandler((data, response, error, elapsedTime))
            
        }.resume()

    }
}
