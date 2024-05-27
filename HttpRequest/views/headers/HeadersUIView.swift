//
//  HeadersUIView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 25/05/2024.
//

import SwiftUI

struct HeadersUIView: View {
    @Binding var request: Request
    @State var bulkEdit = false
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                if !bulkEdit {
                    Text("Key")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Value")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                Image(systemName: "plus.app.fill")
                    .onTapGesture {
                        
                        addHeader(key: "", value: "")
                        
                    }
                Image(systemName: "trash")
                    .onTapGesture {
                        request.headers = []
                    }
                Image(systemName: "square.and.pencil")
                    .onTapGesture {
                        
                        bulkEdit.toggle()
                        
                        //let params = parseTextIntoHeader(text: text)
                        
                        // print(params)

//                        if !params.isEmpty {
//                            params.forEach { parameter in
//                                request.headers.append(parameter)
//                            }
//                        }
                        
                    }.foregroundColor(bulkEdit ? .blue : .primary)

            }
            
            Divider()
            
            
            if !bulkEdit {
                ForEach($request.headers) { $header in
                    HeaderRow(header: $header, removeHeader: removeHeader)
                }
            } else {
                VStack(alignment: .leading) {
                    Text("Auto-generated headers are not visible in bulk edit \nEntries are separated by newline \nKeys and values are separated by : \nPrepend # to any row you want to add but keep disabled").foregroundColor(.gray)
                    
                    TextEditor(text: $text)
                        .padding(4)
                        .border(Color.gray, width: 1)
                        .frame(height: 200)
                        .onAppear(perform: {
                            // convert headers in request into :
                            let textHeaders = request.headers.map { header in
                                var key = header.key
                                var value = header.value
                                var enabled = header.enabled
                                
                                if  !enabled {
                                    key = "#" + key
                                }
                                
                                return key + " : " + value + "\n"
                                
                            }
                            
                            text = textHeaders.joined()
                            
                        })
                        .onDisappear(perform: {
                            // convert the text in editor into headers
                            
                            request.headers =  parseTextIntoHeader(text: text)
                        })
                }.padding(5)
            }

            Spacer()
        }

    }
    
    func addHeader(key: String, value: String) {
        
        request.headers.append(Header(key: key, value: value, enabled: true))
            
        print(request.headers)
        
    }
    
    func removeHeader(id: UUID) {
        request.headers = request.headers.filter { header in
            header.id == id
        }
    }
    
    func parseTextIntoHeader(text: String) -> [Header] {
        let entries = text.split(separator: "\n")
        let headers = entries.map { entry in
            let keysValues = entry.split(separator: ":")
            // construct Header
            
            var key = String(keysValues[0])
            let value = String(keysValues[1])
            let enabled = entry.starts(with: "#") ? false : true
            
            if !enabled {
                key = String(key.dropFirst())
            }
            
            return Header(key: key, value: value, enabled: enabled)
        }
        return headers
    }
}

struct HeaderRow: View {
    
    @Binding var header: Header
    var removeHeader: (_ index: UUID) -> Void
    
    var body: some View {
        HStack {
            TextField("Key", text: $header.key)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Value", text: $header.value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Toggle(isOn: $header.enabled) {
                
            }
            Image(systemName: "trash")
                .onTapGesture {
                    removeHeader(header.id)
                }

        }
    }
}

struct Preview: View {
    @State var request = Request()

    var body: some View {
        HeadersUIView(request: $request)
    }
    init(request: Request = Request()) {
//        var r = request
//        r.headers = [
//            Header(key: "param1", value: "value1", enabled: true),
//            Header(key: "param2", value: "value2", enabled: false)
//        ]

        self.request = request
        
    }
}

#Preview {
    Preview()
}

