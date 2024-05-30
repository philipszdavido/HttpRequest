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
            return "none"
        } else if type == .form_data {
            return "form-data"
        } else if type == .raw {
            return "raw"
        } else if type == .x_www_form_urlencoded {
            return "x-www-form-urlencoded"
        } else if type == .graphql {
            return "graphql"
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
                        request.body.selected = selectedBodyType.type
                    } label: {
                        Text(bodyType.name())
                    }
                }
                
            }
            
//            Button {
//                print(request.bodyContentTypes)
//            } label: {
//                Text("See Req")
//            }

            
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
                RawView(request: $request)
            }
            
            if selectedBodyType.type == .graphql {
                GraphQLView(request: $request)
            }
            Spacer()
        }

    }
}

struct FormDataView: View {
    
    @Binding var request: Request
    
//    @State var formData = [FormData(key: "", value: "", enabled: true)] {
//        didSet {
//            print(formData)
//        }
//    }
        
    var body: some View {
        
        KeyValueView<FormData>(bindings: $request.body.formData, remove: removeFormData, parseText: parseText, addNew: addNew, deleteAll: deleteAll)

    }
            
    func removeFormData(id: UUID) {
        request.body.formData = request.body.formData.filter { binding in
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
        
        request.body.formData += [FormData(key: key, value: value, enabled: true)]
            
        // print(formData)
        
    }
    
    func addNew() {
        request.body.formData += [FormData(key: "", value: "", enabled: true)]

    }
    
    func deleteAll() {
        request.body.formData = []
    }

  

}

struct XWwwFormUrlencodedView: View {
    
    @Binding var request: Request
    
//    @State var xWwwFormUrlencoded = [XWWWUrlEncoded(key: "", value: "", enabled: true)]
    
    var body: some View {
        
        KeyValueView<XWWWUrlEncoded>(bindings: $request.body.xwwwUrlEncoded, remove: removeFormData, parseText: parseText, addNew: addNew, deleteAll: deleteAll)

    }
    
    func removeFormData(id: UUID) {
        request.body.xwwwUrlEncoded = request.body.xwwwUrlEncoded.filter { binding in
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
        
        request.body.xwwwUrlEncoded.append(XWWWUrlEncoded(key: key, value: value, enabled: true))
            
        // print(xWwwFormUrlencoded)
        
    }
    
    func addNew() {
        request.body.xwwwUrlEncoded.append(XWWWUrlEncoded(key: "", value: "", enabled: true))
    }
    
    func deleteAll() {
        request.body.xwwwUrlEncoded = []
    }
  

}

struct RawView: View {
    @Binding var request: Request

    var body: some View {
        TextEditor(text: $request.body.raw)
            .padding(4)
            .border(Color.gray, width: 1)
            .frame(height: 200)

    }
}

struct GraphQLView: View {
    @Binding var request: Request

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("QUERY")
                TextEditor(text: $request.body.graphql.query)
                    .padding(4)
                    .border(Color.gray, width: 1)
                .frame(height: 200)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("GRAPHQL VARIABLES")
                TextEditor(text: $request.body.graphql.variables)
                    .padding(4)
                    .border(Color.gray, width: 1)
                .frame(height: 200)
            }
        }
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
    var addNew: () -> Void
    var deleteAll: () -> Void

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
                        addNew()
                    }
                Image(systemName: "trash")
                    .onTapGesture {
                        deleteAll()
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
                            get: { binding[keyPath: \.value] },
                            set: { binding[keyPath: \.value] = $0 }
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
                                let value = binding.value
                                let enabled = binding.enabled
                                
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
