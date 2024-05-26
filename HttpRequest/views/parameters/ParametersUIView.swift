//
//  ParametersUIView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 25/05/2024.
//

import SwiftUI

struct ParametersUIView: View {
    @Binding var parameters: [Parameter]
    
    @State private var dummyKey = ""
    @State private var dummyValue = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Key")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Value")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Image(systemName: "plus.app.fill")
                    .onTapGesture {
                            addParameter(key: "", value: "")
                        }
                

            }
            Divider()
            ForEach($parameters) { $parameter in
                ParamRow(parameter: $parameter)
            }

//            HStack {
//                TextField("Key", text: $dummyKey)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .onChange(of: dummyKey) { newValue in
//                        addParameter(key: newValue, value: "")
//                        dummyKey = ""
//                    }
//                
//                TextField("Value", text: $dummyValue)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .onChange(of: dummyValue) { newValue in
//                        addParameter(key: "", value: newValue)
//                        dummyValue = ""
//                        
//                    }
//            }

            Spacer()
        }

    }
    
    func addParameter(key: String, value: String) {
        
        do {
            
            try parameters.append(Parameter(key: key, value: value))
            
            print(parameters)
            print("END")
        } catch {
            print(error)
        }
    }
}

struct ParamRow: View {
    @Binding var parameter: Parameter
    
    var body: some View {
        HStack {
            TextField("Key", text: $parameter.key)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Value", text: $parameter.value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

// Preview
struct ParametersUIView_Previews: PreviewProvider {
    @State static var parameters = [
        Parameter(key: "param1", value: "value1"),
        Parameter(key: "param2", value: "value2")
    ]
    
    static var previews: some View {
        ParametersUIView(parameters: $parameters)
    }
}
