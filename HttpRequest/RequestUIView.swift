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
    
    @State private var protocolType = "https://"
    
    var body: some View {
        VStack {
            HStack {
                Text("Untitled POST request")
                Spacer()
            }
            HStack {
                
                MenuButton(label: Text(protocolType)) {
                    Button(action: {
                        protocolType = "http://"
                        //request.protocolType = protocolType
                    }) {
                        Text("http://")
                    }
                    
                    Button(action: {
                        protocolType = "https://"
                        //request.protocolType = protocolType
                    }) {
                        Text("https://")
                    }
                }
                .frame(width: 100)

                
                TextField("Enter URL", text: $request.url)
                Button(action: {
                    loadingHttpRequest = true
                    httpRequest.makeRequest(request: request) { (data: Data?, response: URLResponse?, error: Error?) in
                        
                        responseObject.data = data;
                        responseObject.response = response as? HTTPURLResponse;
                        responseObject.error = error;
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
            TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
                ResponseUIView(responseObject: responseObject)
            }

        }
        
        
    }
}

#Preview {
    RequestUIView().frame(width: 600, height: 400)
}


