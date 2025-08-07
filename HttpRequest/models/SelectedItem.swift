//
//  SelectedItem.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 26/06/2025.
//

import Foundation

enum SelectedItemType: Int {
    case request;
    case collection;
    case env;
}

class SelectedItem {
    var type: SelectedItemType
    
    init() {
        self.type = .request
    }
    
    init(type: SelectedItemType) {
        self.type = type
    }
    
}
