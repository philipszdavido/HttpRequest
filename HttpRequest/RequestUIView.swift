//
//  RequestUIView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 24/05/2024.
//

import Foundation
import SwiftUI
// https://www.google.com

let PADDING_TOP: CGFloat = 10.0

struct RequestUIView: View {
    @Environment(\.modelContext) var modelContext

    @State var url: String = ""
    @State public var selectedTab = 1
    @State public var request = Request()
    @State public var method = "GET"
    
    let httpRequest = HttpService()
    @State private var loadingHttpRequest = false
    @ObservedObject var responseObject = Response()

    var body: some View {
        VStack {
            
            HStack {
                Text("Untitled POST request")
                Spacer()
            }.padding(PADDING_TOP)
            
            HStack {
                
                MenuButton(label: Text(method)) {
                    Button(action: {
                        method = "GET"
                        request.method = method
                    }) {
                        Text("GET")
                            .foregroundStyle(methodColor(method: "GET"))
                    }
                    
                    Button(action: {
                        method = "POST"
                        request.method = method
                    }) {
                        Text("POST").foregroundColor(.yellow)
                    }
                    
                    Button(action: {
                        method = "PUT"
                        request.method = method
                    }) {
                        Text("PUT").foregroundColor(.orange)
                    }

                    Button(action: {
                        method = "DELETE"
                        request.method = method
                    }) {
                        Text("DELETE").foregroundColor(.red)
                    }

                    Button(action: {
                        method = "OPTIONS"
                        request.method = method
                    }) {
                        Text("OPTIONS").foregroundColor(.pink)
                    }

                }
                .frame(width: 100)

                TextField("Enter URL", text: $request.url)
                
                Button(action: {
                    
                    modelContext.insert(History(request: request))
                    
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
            }.padding(PADDING_TOP)
            
            Spacer()
            TabView(selection: $selectedTab) {
                AuthorizationUIView(request: $request).padding([.top, .trailing, .leading], PADDING_TOP).tabItem { Text("Auth") }.tag(1)
                BodyUIView(request: $request).padding([.top, .trailing, .leading], PADDING_TOP).tabItem { Text("Body") }.tag(2)
                HeadersUIView(request: $request).padding([.top, .trailing, .leading], PADDING_TOP).tabItem { Text("Headers") }.tag(3)
                ParametersUIView(request: $request).padding([.top, .trailing, .leading], PADDING_TOP).tabItem { Text("Parameters") }.tag(4)
            }.padding([.top], PADDING_TOP)
            
            if !loadingHttpRequest {
                StatsView(responseObject: responseObject)
                    .padding([.top], PADDING_TOP)
                ResponseUIView(responseObject: responseObject)
                    .padding([.top], PADDING_TOP)
            } else {
                ProgressView().padding(.all, 10).frame(height: 200)
            }

        }
        .onAppear(perform: {
            if request.method.isEmpty {
                request.method = method
//                request.url = "https://jsonplaceholder.typicode.com/posts/"
                request.url = "https://www.google.com/"
            }
        })
        
        
    }
}

#Preview {
    RequestUIView().frame(width: 600, height: 400)
        .modelContainer(for: [History.self], inMemory: true)
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
