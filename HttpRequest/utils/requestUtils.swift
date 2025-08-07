//
//  requestUtils.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 26/06/2025.
//

import Foundation
import SwiftUICore

func methodColor(method: String) -> Color {
    switch method {
    case "get":
        return .green
    case "post":
        return .red
    case "put":
        return .purple
    default:
        return .green
    }
}
