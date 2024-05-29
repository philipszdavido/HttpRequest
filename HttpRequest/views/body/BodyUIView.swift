//
//  BodyUIView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 25/05/2024.
//

import SwiftUI

struct BodyType: Identifiable {
    let id = UUID()
    var type: BodyTypes;
    
    func name() -> String {
        let type = self.type
        if type == .none {
            return "None"
        } else if type == .form_data {
            return "Form Data"
        } else if type == .raw {
            return "Raw"
        } else if type == .x_www_form_urlencoded {
            return "X WWW Form URLEncoded"
        } else if type == .graphql {
            return "GraphQL"
        }
        return ""
    }
}

struct BodyUIView: View {
    @Binding var request: Request
    
    @State var selectedBodyType = BodyType(type: .none)
    
    private let bodyTypes = [
        BodyType(type: .none),
        BodyType(type: .form_data),
        BodyType(type: .x_www_form_urlencoded),
        BodyType(type: .raw),
        BodyType(type: .graphql)
    ]

    var body: some View {
        VStack {
            MenuButton(label: Text(selectedBodyType.name())) {
                
                ForEach(bodyTypes) { bodyType in
                    Button {
                        selectedBodyType = bodyType
                    } label: {
                        Text(bodyType.name())
                    }
                }
                
            }
            
            if selectedBodyType.type == .none {
                Text("This request does not have a body")
            }
            
            if selectedBodyType.type == .form_data {
                FormDataView(request: $request)
            }
            
            if selectedBodyType.type == .x_www_form_urlencoded {
                XWwwFormUrlencodedView(request: $request)
            }
            
            if selectedBodyType.type == .raw {
                RawView()
            }
            
            if selectedBodyType.type == .graphql {
                GraphQLView()
            }
            Spacer()
        }

    }
}

struct FormDataView: View {
    
    @Binding var request: Request
    
    @State var formData = [FormData(key: "", value: "", enabled: true)]
        
    var body: some View {
        
        KeyValueView<FormData>(bindings: $formData, remove: removeFormData, parseText: parseText)

    }
        
    func removeFormData(id: UUID) {
        formData = formData.filter { binding in
            binding.id == id
        }
    }
    
    func parseText(text: String) -> [FormData] {
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
            
            return FormData(key: key, value: value, enabled: enabled)
        }
        return parameters
    }
    
    func add(key: String, value: String) {
        
        formData.append(FormData(key: key, value: value, enabled: true))
            
        print(formData)
        
    }
  

}

struct XWwwFormUrlencodedView: View {
    
    @Binding var request: Request
    
    @State var xWwwFormUrlencoded = [XWWWUrlEncoded(key: "", value: "", enabled: true)]

    var body: some View {
        
        KeyValueView<XWWWUrlEncoded>(bindings: $xWwwFormUrlencoded, remove: removeFormData, parseText: parseText)

    }
    
    func removeFormData(id: UUID) {
        xWwwFormUrlencoded = xWwwFormUrlencoded.filter { binding in
            binding.id == id
        }
    }
    
    func parseText(text: String) -> [XWWWUrlEncoded] {
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
            
            return XWWWUrlEncoded(key: key, value: value, enabled: enabled)
        }
        return parameters
    }
    
    func add(key: String, value: String) {
        
        xWwwFormUrlencoded.append(XWWWUrlEncoded(key: key, value: value, enabled: true))
            
        print(xWwwFormUrlencoded)
        
    }
  

}

struct RawView: View {
    var body: some View {
        TextEditor(text: .constant(""))
            .padding(4)
            .border(Color.gray, width: 1)
            .frame(height: 200)

    }
}

struct GraphQLView: View {
    var body: some View {
        TextEditor(text: .constant(""))
            .padding(4)
            .border(Color.gray, width: 1)
            .frame(height: 200)

    }
}

struct BodyUIView_Preview: View {
    @State var request = Request()

    var body: some View {
        BodyUIView(request: $request)
    }
}

#Preview {
    BodyUIView_Preview()
}

struct KeyValueView<C: KeyValueEnabled & Codable & Identifiable>: View {

    @State var bulkEdit = false
    @State private var text: String = ""
    
    @Binding var bindings: [C];
    
    var remove: (_ id: UUID) -> Void;
    var parseText: (_ text: String) -> [C]

    var body: some View {
        VStack{
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
                        
                    }
                Image(systemName: "trash")
                    .onTapGesture {
                    }
                Image(systemName: "square.and.pencil")
                    .onTapGesture {
                        
                        bulkEdit.toggle()
                        
                    }.foregroundColor(bulkEdit ? .blue : .primary)
                
            }
            
            Divider()
            
            if !bulkEdit {
                ForEach($bindings) { $binding in
                    HStack {
                        TextField("Key", text: Binding(
                            get: { binding[keyPath: \.key] },
                            set: { binding[keyPath: \.key] = $0 }
                        ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Value", text: Binding(
                            get: { binding[keyPath: \.key] },
                            set: { binding[keyPath: \.key] = $0 }
                        ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Toggle(isOn: $binding.enabled) {
                            
                        }
                        Image(systemName: "trash")
                            .onTapGesture {
                                remove(binding.id)
                            }

                    }
                }
            } else {
                VStack(alignment: .leading) {
                    Text("Entries are separated by newline \nKeys and values are separated by : \nPrepend # to any row you want to add but keep disabled").foregroundColor(.gray)
                    
                    TextEditor(text: $text)
                        .padding(4)
                        .border(Color.gray, width: 1)
                        .frame(height: 200)
                        .onAppear(perform: {
                            // convert params in request into :
                            let textParams = bindings.map { binding in
                                var key = binding.key
                                var value = binding.value
                                var enabled = binding.enabled
                                
                                if  !enabled {
                                    key = "#" + key
                                }
                                
                                return key + " : " + value + "\n"
                                
                            }
                            
                            text = textParams.joined()
                            
                        })
                        .onDisappear(perform: {
                            // convert the text in editor into params
                            
                            bindings = parseText(text)
                        })
                }.padding(5)
            }

            Spacer()

        }

    }
  
}
