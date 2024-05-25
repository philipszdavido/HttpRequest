//
//  RequestUIView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 24/05/2024.
//

import Foundation
import SwiftUI

struct RequestUIView: View {
    @State var url: String = ""
    
    let httpRequest = HttpService()
    
    var body: some View {
        VStack {
            HStack {
                Text("Untitled POST request")
                Spacer()
            }
            HStack {
                TextField("Enter URL", text: $url)
                Button(action: {
                    httpRequest.makeRequest()
                }, label: {
                    Text("Send")
                })
            }
            Spacer()
            TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
                Text("Tab Content 1").tabItem { Text("Auth") }.tag(1)
                Text("Tab Content 2").tabItem { Text("Body") }.tag(2)
                Text("Tab Content 2").tabItem { Text("Headers") }.tag(3)
                Text("Tab Content 2").tabItem { Text("Parameters") }.tag(4)
            }
            TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
                Text("Tab Content 1").tabItem { Text("Response") }.tag(1)
                Text("Tab Content 2").tabItem { Text("Cookies") }.tag(2)
            }

        }
        
        
    }
}

#Preview {
    RequestUIView().frame(width: 600, height: 400)
}
