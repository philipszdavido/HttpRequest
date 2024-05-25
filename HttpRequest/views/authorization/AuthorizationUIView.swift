//
//  AuthorizationUIView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 25/05/2024.
//

import SwiftUI

enum AuthTypesEnums {
    case none
    case inherit
    case basic
    case bearer
    case oauth_2_0
    case api_key
}

struct AuthTypes: Identifiable {
    var id: AuthTypesEnums;
    var name: String;
}

struct AuthorizationUIView: View {
    
    @State private var authType = AuthTypes(id: .none, name: "")
    
    private var authTypes = [
        AuthTypes(id: .inherit, name: "Inherit"),
        AuthTypes(id: .none, name: "None"),
        AuthTypes(id: .basic, name: "Basic Auth"),
        AuthTypes(id: .bearer, name: "Bearer"),
        AuthTypes(id: .oauth_2_0, name: "OAuth 2.0"),
        AuthTypes(id: .api_key, name: "API Key")
    ]
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Authorization Type")
                    MenuButton(label: Text(authType.name)) {
                        
                        ForEach(authTypes) { _authType in
                            Button {
                                authType = _authType
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
                    BasicAuthView()
                }
                
                if authType.id == .bearer {
                    BearerAuthView()
                }
                
                if authType.id == .api_key {
                    API_Key_View()
                }
                
                if authType.id == .oauth_2_0 {
                    OAuth_2_0_View()
                }
                
            }
            Spacer()
        }
    }
}

#Preview {
    AuthorizationUIView()
}


struct BasicAuthView: View {

    @State private var username = ""
    @State private var password = ""

    var body: some View {
        TextField("Username", text: $username)
        TextField("Password", text: $password)
    }
    
}


struct BearerAuthView: View {
    
    @State private var token = ""
    
    var body: some View {
        TextField("Token", text: $token)
    }
}


struct OAuth_2_0_View: View {
    
    @State private var token = ""
    
    var body: some View {
        TextField("Token", text: $token)
    }
}


struct API_Key_View: View {
    
    @State private var key = ""
    @State private var value = ""
    @State private var passBy = ""
    @State private var passByValue = ""

    var body: some View {
        TextField("Key", text: $key)
        TextField("Value", text: $value)
        
        HStack {
            Text("Pass by:")
            MenuButton(label: Text(passBy)) {
                
                ForEach(["Headers", "Query Parameters"], id: \.self) { type in
                    Button {
                        
                        passBy = type
                        passByValue = type.lowercased().split(separator: " ").joined()
                        
                        print(passByValue)
                    } label: {
                        Text(type)
                    }
                }
                
            }
        }


    }
}
