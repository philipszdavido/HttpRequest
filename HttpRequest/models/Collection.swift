//
//  Collection.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 29/05/2024.
//
//
//import Foundation
//import SwiftData
//
//enum CollectionItemType: Codable {
//    case file
//    case folder
//}
//
//class Folder {
//    var id = UUID()
//    var items: [CollectionItems]
//    
//    init(id: UUID = UUID(), items: [CollectionItems]) {
//        self.id = id
//        self.items = items
//    }
//    
//}
//
//class CollectionItems {
//    var id = UUID()
//    var type: CollectionItemType;
//    var value: Any<Folder : Request>;
//    
//    init(id: UUID = UUID(), type: CollectionItemType, value: Any) {
//        self.id = id
//        self.type = type
//        self.value = value
//    }
//}
//
//@Model
//class Collection {
//    var name: String;
//    var items: [CollectionItems]
//    
//    init(name: String, items: [CollectionItems]) {
//        self.name = name
//        self.items = items
//    }
//}

import Foundation
import SwiftData

//enum CollectionItemType {
//    case file
//    case folder
//}
//
//protocol CollectionItemValue {}
//
//@Model
//class Folder: CollectionItemValue {
//    var id: UUID
//    var items: [CollectionItems]
//    
//    init(id: UUID = UUID(), items: [CollectionItems]) {
//        self.id = id
//        self.items = items
//    }
//}
//
//@Model
//class File: CollectionItemValue {
//    var id: UUID
//    var value: Request
//    
//    init(id: UUID = UUID(), value: Request) {
//        self.id = id
//        self.value = value
//    }
//}
//
//@Model
//class CollectionItems {
//    var id: UUID
//    var type: CollectionItemType
//    var value: CollectionItemValue
//    
//    init(id: UUID = UUID(), type: CollectionItemType, value: CollectionItemValue) {
//        self.id = id
//        self.type = type
//        self.value = value
//    }
//}

enum CollectionItemType: String, Codable {
    case file
    case folder
}

@Model
class Folder {
    var id: UUID
    var items: [CollectionItem]

    init(id: UUID = UUID(), items: [CollectionItem] = []) {
        self.id = id
        self.items = items
    }
}

@Model
class File {
    var id: UUID
    var request: Request

    init(id: UUID = UUID(), request: Request) {
        self.id = id
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
