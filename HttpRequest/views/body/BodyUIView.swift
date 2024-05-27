//
//  BodyUIView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 25/05/2024.
//

import SwiftUI

struct BodyUIView: View {
    @Binding var request: Request
    
    @State var selectedBodyType = "none"
    
    private let bodyTypes = [
        "none",
        "form-data",
        "x-www-form-urlencoded",
        "raw",
        "graphql"
    ]

    var body: some View {
        MenuButton(label: Text(selectedBodyType)) {
            
            ForEach(bodyTypes, id:\.self) { bodyType in
                Button {
                    selectedBodyType = bodyType
                } label: {
                    Text(bodyType)
                }
            }
            
        }
        
        if selectedBodyType == "none" {
            Text("This request does not have a body")
        }
        
        if selectedBodyType == "form-data" {
            FormDataView()
        }
        
        if selectedBodyType == "x-www-form-urlencoded" {
            XWwwFormUrlencodedView()
        }
        
        if selectedBodyType == "raw" {
            RawView()
        }
        
        if selectedBodyType == "graphql" {
            GraphQLView()
        }

    }
}

struct FormDataView: View {
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

struct XWwwFormUrlencodedView: View {
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
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
