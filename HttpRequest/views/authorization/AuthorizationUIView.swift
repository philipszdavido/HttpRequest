//
//  AuthorizationUIView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 25/05/2024.
//

import SwiftUI

struct AuthTypes: Identifiable {
    var id: AuthType;
    var name: String;
}

struct AuthorizationUIView: View {

    @State private var authType = AuthTypes(id: .none, name: "None")
    
    var authTypes = [
        AuthTypes(id: .inherit, name: "Inherit"),
        AuthTypes(id: .none, name: "None"),
        AuthTypes(id: .basic, name: "Basic Auth"),
        AuthTypes(id: .bearer, name: "Bearer"),
        AuthTypes(id: .oauth2, name: "OAuth 2.0"),
        AuthTypes(id: .apikey, name: "API Key")
    ]

    @Binding var request: Request

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Authorization Type")
                    MenuButton(label: Text(authType.name)) {
                        
                        ForEach(authTypes) { _authType in
                            Button {
                                authType = _authType
                                request.authorization.selected = _authType.id
                            } label: {
                                Text(_authType.name)
                            }
                        }
                        
                    }
                    Spacer()
                    Button {
                        authType = AuthTypes(id: .none, name: "")
                    } label: {
                        Text("Clear")
                    }
                    
                }
                
                Divider()
                
                if authType.id == .none {
                    
                }
                
                if authType.id == .inherit {
                    Text("Auth is inherited")
                }
                
                if authType.id == .basic {
                    BasicAuthView(request: $request)
                }
                
                if authType.id == .bearer {
                    BearerAuthView(request: $request)
                }
                
                if authType.id == .apikey {
                    API_Key_View(request: $request)
                }
                
                if authType.id == .oauth2 {
                    OAuth_2_0_View(request: $request)
                }
                
            }
            Spacer()
        }
    }
}

struct BasicAuthView: View {

    @Binding var request: Request
        
    var body: some View {
        VStack {
            TextField("Username", text: $request.authorization.basic.username)
            TextField("Password", text: $request.authorization.basic.password)
        }.onAppear(perform: {
        })
    }
    
}


struct BearerAuthView: View {
    @Binding var request: Request
    
    var body: some View {
        TextField("Token", text: $request.authorization.bearer.token)
    }
}


struct OAuth_2_0_View: View {
    @Binding var request: Request

    @State private var token = ""
    
    var body: some View {
        TextField("Token", text: $token)
    }
}

struct APIKeyAddTo: Identifiable {
    let id = UUID()
    var name: String;
    var type: ApiKeyEnum;
}

struct API_Key_View: View {
    @Binding var request: Request
    
    @State private var addTo = APIKeyAddTo(name: "Headers", type: .header)

    var body: some View {
        TextField("Key", text: $request.authorization.apikey.key)
        TextField("Value", text: $request.authorization.apikey.value)
        
        HStack {
            Text("Pass by:")
            MenuButton(label: Text(addTo.name)) {
                
                ForEach([APIKeyAddTo(name: "Headers", type: .header), APIKeyAddTo(name: "Query Parameters", type: .query_param)]) { type in
                    Button {
                        
                        request.authorization.apikey.addTo = type.type
                        
                        addTo = type
                        
                        // print(addTo, request.authorization)
                    } label: {
                        Text(type.name)
                    }
                }
                
            }
        }


    }
}


struct AuthorizationUIView_Preview: View {

    @State var request = Request()

    var body: some View {

        AuthorizationUIView(request: $request)

    }
}

#Preview {
    AuthorizationUIView_Preview()
}
