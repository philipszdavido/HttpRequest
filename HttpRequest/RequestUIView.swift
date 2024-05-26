//
//  RequestUIView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 24/05/2024.
//

import Foundation
import SwiftUI
// https://www.google.com

struct RequestUIView: View {
    @State var url: String = ""
    @State private var selectedTab = 1
    
    let httpRequest = HttpService()
    @State private var request = Request()
    @ObservedObject var responseObject = Response()
    
    @State private var loadingHttpRequest = false
    
    @State private var method = "GET"
    
    var body: some View {
        VStack {
            HStack {
                Text("Untitled POST request")
                Spacer()
            }
            HStack {
                
                MenuButton(label: Text(method)) {
                    Button(action: {
                        method = "GET"
                        request.method = method
                    }) {
                        Text("GET").foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        method = "POST"
                        request.method = method
                    }) {
                        Text("POST").foregroundColor(.yellow)
                    }
                }
                .frame(width: 100)

                
                TextField("Enter URL", text: $request.url)
                Button(action: {
                    loadingHttpRequest = true;
                                                            
                    httpRequest.makeRequest(request: request) { (data: Data?, response: URLResponse?, error: Error?, timeInterval: TimeInterval) in
                                                
                        responseObject.data = data;
                        responseObject.response = response as? HTTPURLResponse;
                        responseObject.error = error;
                        responseObject.timeTaken = timeInterval
                                                
                        loadingHttpRequest = false
                    }
                }, label: {
                    if loadingHttpRequest  { Text("Sending...") } else { Text("Send")
                    }
                }).disabled(loadingHttpRequest || request.url.isEmpty)
            }
            Spacer()
            TabView(selection: $selectedTab) {
                AuthorizationUIView().tabItem { Text("Auth") }.tag(1)
                BodyUIView().tabItem { Text("Body") }.tag(2)
                HeadersUIView().tabItem { Text("Headers") }.tag(3)
                ParametersUIView(request: $request).tabItem { Text("Parameters") }.tag(4)
            }
            if !loadingHttpRequest {
                StatsView(responseObject: responseObject)
                ResponseUIView(responseObject: responseObject)
            } else {
                ProgressView().padding(.all, 10).frame(height: 200)
            }

        }
        .onAppear(perform: {
            if request.method.isEmpty {
                request.method = method
                request.url = "https://jsonplaceholder.typicode.com/posts/"
            }
        })
        
        
    }
}

#Preview {
    RequestUIView().frame(width: 600, height: 400)
}


struct StatsView: View {
    
    @ObservedObject var responseObject: Response;
    
    var statusCodeColor: Color {
        
        let code = responseObject.statusCode()
        
        if code >= 100 && code <= 199 {
            return .brown
        }
        
        if code >= 200 && code <= 299 {
            return .green
        }
        
        if code >= 300 && code <= 399 {
            return .blue
        }
        
        if code >= 400 && code <= 499 {
            return .red
        }
        
        if code >= 500 && code <= 599 {
            return .red
        }
        
        return .primary
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            HStack(spacing: 0) {
                Text("Status: ")
                Text("\(responseObject.statusCode())")
                    .foregroundColor(statusCodeColor)
            }
            
            Text("Time: \(responseObject.timeTaken) secs")
            Text("Size: \(responseObject.size()) bytes")
        }
    }
}
