//
//  Body.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 29/05/2024.
//

import Foundation


struct FormData: Codable, Identifiable, KeyValueEnabled {
    var id = UUID()
    var key: String;
    var value: String;
    var enabled: Bool;
}

struct XWWWUrlEncoded: Codable, Identifiable, KeyValueEnabled {
    var id = UUID()
    var key: String;
    var value: String;
    var enabled: Bool;
}

