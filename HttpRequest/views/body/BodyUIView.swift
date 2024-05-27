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
        "orm-data",
        "x-www-form-urlencoded",
        "raw",
        "graphql"
    ]

    var body: some View {
        MenuButton(label: Text(selectedBodyType)) {
            
            ForEach(bodyTypes, id:\.self) { bodyType in
                Button {
                    
                } label: {
                    Text(bodyType)
                }
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
