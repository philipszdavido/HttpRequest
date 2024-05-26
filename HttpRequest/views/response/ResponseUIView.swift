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
            
            ContentsView(data: responseObject).tabItem { Text("Response") }.tag(1)
            
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
    
    var data: Response
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
            Button(action: {
                copyToClipboardMac(text: data.getData())
            }) {
                Text("Copy")
            }
            
            Button(action: {
                
                if let _data = data.data {
                    download(data: _data)
                }
                
            }) {
                Text("Download")
            }
        }

            ScrollView {
                Text(data.getData())
            }
        }
    }
    
    func copyToClipboardMac(text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        print("Text copied to clipboard: \(text)")
    }
    
    func getDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func download(data: Data) {
        
        guard let documentsDirectory = getDocumentsDirectory() else {
                return
            }
        
        let saveURL = documentsDirectory.appendingPathComponent("downloadedFile.json")
        do {
            try data.write(to: saveURL, options: .atomic)
        } catch {
            print("Error downloading file: \(error.localizedDescription)")
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
