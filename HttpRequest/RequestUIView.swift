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
                    loadingHttpRequest = true
                    
                    let startTime = Date()
                    
                    httpRequest.makeRequest(request: request) { (data: Data?, response: URLResponse?, error: Error?) in
                        
                        let endTime = Date()
                        let elapsedTime = endTime.timeIntervalSince(startTime)
                        
                        responseObject.data = data;
                        responseObject.response = response as? HTTPURLResponse;
                        responseObject.error = error;
                        responseObject.timeTaken = Int(elapsedTime)
                        
                        loadingHttpRequest = false
                    }
                }, label: {
                    if loadingHttpRequest  { Text("Sending...") } else { Text("Send")
                    }
                }).disabled(loadingHttpRequest || request.url.isEmpty)
            }
            Spacer()
            TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
                Text("Tab Content 1").tabItem { Text("Auth") }.tag(1)
                Text("Tab Content 2").tabItem { Text("Body") }.tag(2)
                Text("Tab Content 2").tabItem { Text("Headers") }.tag(3)
                Text("Tab Content 2").tabItem { Text("Parameters") }.tag(4)
            }
            if !loadingHttpRequest {
                StatsView(responseObject: responseObject)
                ResponseUIView(responseObject: responseObject)
            } else {
                ProgressView().padding(.all, 10).frame(height: 200)
            }

        }
        
        
    }
}

#Preview {
    RequestUIView().frame(width: 600, height: 400)
}


struct StatsView: View {
    
    @ObservedObject var responseObject: Response;
    
    var body: some View {
        HStack {
            Spacer()
            Text("Status: \(responseObject.statusCode())")
            Text("Time: \(responseObject.timeTaken)")
            Text("Size: \(responseObject.size())")
        }
    }
}
