//
//  requestUtils.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 26/06/2025.
//

import Foundation
import SwiftUICore

func methodColor(method: String) -> Color {
    switch method.lowercased() {
    case "get":
        return .green
    case "post":
        return .red
    case "put":
        return .purple
    case "delete":
        return .red
    case "options":
        return .orange
    default:
        return .green
    }
}
