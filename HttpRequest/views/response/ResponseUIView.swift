//
//  ResponseUIView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 25/05/2024.
//

import SwiftUI

struct ResponseUIView: View {
    
    @ObservedObject var responseObject: Response
    
    var body: some View {
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            
            ContentsView(data: responseObject.getData()).tabItem { Text("Response") }.tag(1)
            
            CookiesView().tabItem { Text("Cookies") }.tag(2)
            
            HeadersView(headers: responseObject.getHeaders()).tabItem { Text("Headers") }.tag(3)
        }
    }
    
}

#Preview {
    ResponseUIView(responseObject: Response(data: nil, response: nil, error: nil))
}


struct CookiesView: View {
        
    var body: some View {
        ScrollView {
            Text("")
        }
    }
}

struct ContentsView: View {
    
    var data: String
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
            Button(action: {
                
            }) {
                Text("Copy")
            }
            
            Button(action: {
                
            }) {
                Text("Download")
            }
        }

            ScrollView {
                Text(data)
            }
        }
    }
}


struct HeadersView: View {
    var headers: [AnyHashable: Any]
    
    var body: some View {
        List {
            ForEach(headersArray, id: \.key) { header in
                HStack {
                    Text("\(header.key.description):")
                        .fontWeight(.bold)
                    Text("\(String(describing: header.value))")
                        .lineLimit(nil)
                }
            }
        }.onAppear(perform: {
            print(headers)
        })
    }
    
    // Convert dictionary to array of tuples
    private var headersArray: [(key: AnyHashable, value: Any)] {
        headers.map { ($0.key, $0.value) }
    }
}

#Preview {
    HeadersView(headers: ["Content-Type": "application/json", "Authorization": "Bearer YOUR_API_TOKEN"])
}
