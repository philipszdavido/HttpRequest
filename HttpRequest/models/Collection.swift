//
//  Collection.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 29/05/2024.
//
//

import Foundation
import SwiftData

enum CollectionItemType: String, Codable {
    case file
    case folder
}

@Model
class Folder {
    var id: UUID
    var name: String
    var items: [CollectionItem]

    init(id: UUID = UUID(), name: String, items: [CollectionItem]) {
        self.id = id
        self.name = name
        self.items = items
    }
}

@Model
class File {
    var id: UUID
    var name: String
    var request: Request

    init(id: UUID = UUID(), name: String, request: Request) {
        self.id = id
        self.name = name
        self.request = request
    }
}

@Model
class CollectionItem {
    var id: UUID
    var type: CollectionItemType

    // Use optional relationships
    var folder: Folder?
    var file: File?

    init(id: UUID = UUID(), type: CollectionItemType, folder: Folder? = nil, file: File? = nil) {
        self.id = id
        self.type = type
        self.folder = folder
        self.file = file
    }
}

@Model
class Collection {
    var id: UUID
    var name: String
    var items: [CollectionItem]

    init(id: UUID = UUID(), name: String, items: [CollectionItem] = []) {
        self.id = id
        self.name = name
        self.items = items
    }
}
