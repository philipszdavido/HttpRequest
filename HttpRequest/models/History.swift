//
//  History.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 25/05/2024.
//

import Foundation
import SwiftData

@Model
class History {
    var request: Request

    init(request: Request) {
        self.request = request
    }
}
