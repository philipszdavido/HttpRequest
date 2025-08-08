//
//  ClickModel.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 08/08/2025.
//

import Foundation
import SwiftUICore

class ClickModel: ObservableObject {
    @ObservedObject static var shared = ClickModel()
    @Published var id: String = ""
}
