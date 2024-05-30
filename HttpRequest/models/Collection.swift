//
//  Collection.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 29/05/2024.
//

import Foundation
import SwiftData

struct Folder: Identifiable, Codable {
    var id = UUID()
    var items: [CollectionItems]
}

struct CollectionItems: Identifiable, Codable {
    var id = UUID()
}

@Model
class Collection {
    var name: String;
    var items: [CollectionItems]
    
    init(name: String, items: [CollectionItems]) {
        self.name = name
        self.items = items
    }
}
