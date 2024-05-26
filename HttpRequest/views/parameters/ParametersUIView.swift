//
//  ParametersUIView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 25/05/2024.
//

import SwiftUI

struct ParametersUIView: View {
    
    @Binding var request: Request
    @State var bulkEdit = false
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Key")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Value")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Image(systemName: "plus.app.fill")
                    .onTapGesture {
                        
                        addParameter(key: "", value: "")
                        
                    }
                Image(systemName: "trash")
                    .onTapGesture {
                        request.parameters = []
                    }
                Image(systemName: "square.and.pencil")
                    .onTapGesture {
                        
                        bulkEdit.toggle()
                        
                        let params = parseTextIntoParams(text: text)
                        
                        // print(params)

                        if !params.isEmpty {
                            params.forEach { parameter in
                                request.parameters.append(parameter)
                            }
                        }
                        
                    }.foregroundColor(bulkEdit ? .blue : .primary)

            }
            
            Divider()
            
            
            if !bulkEdit {
                ForEach($request.parameters) { $parameter in
                    ParamRow(parameter: $parameter, removeParameter: removeParameter)
                }
            } else {
                VStack(alignment: .leading) {
                    Text("Entries are separated by newline \nKeys and values are separated by : \nPrepend # to any row you want to add but keep disabled").foregroundColor(.gray)
                    
                    TextEditor(text: $text)
                        .padding(4)
                        .border(Color.gray, width: 1)
                        .frame(height: 200)
                }.padding(5)
            }

            Spacer()
        }

    }
    
    func addParameter(key: String, value: String) {
        
        request.parameters.append(Parameter(key: key, value: value, enabled: true))
            
        print(request.parameters)
        
    }
    
    func removeParameter(id: UUID) {
        request.parameters = request.parameters.filter { parameter in
            parameter.id == id
        }
    }
    
    func parseTextIntoParams(text: String) -> [Parameter] {
        let entries = text.split(separator: "\n")
        let parameters = entries.map { entry in
            let keysValues = entry.split(separator: ":")
            // construct Parameter
            
            var key = String(keysValues[0])
            let value = String(keysValues[1])
            let enabled = entry.starts(with: "#") ? false : true
            
            if !enabled {
                key = String(key.dropFirst())
            }
            
            return Parameter(key: key, value: value, enabled: enabled)
        }
        return parameters
    }
}

struct ParamRow: View {
    
    @Binding var parameter: Parameter
    var removeParameter: (_ index: UUID) -> Void
    
    var body: some View {
        HStack {
            TextField("Key", text: $parameter.key)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Value", text: $parameter.value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Toggle(isOn: $parameter.enabled) {
                
            }
            Image(systemName: "trash")
                .onTapGesture {
                    removeParameter(parameter.id)
                }

        }
    }
}

#Preview {
    @State var request = Request(parameters: [
        Parameter(key: "param1", value: "value1", enabled: true),
        Parameter(key: "param2", value: "value2", enabled: false)
    ])
    return ParametersUIView(request: $request)
}

