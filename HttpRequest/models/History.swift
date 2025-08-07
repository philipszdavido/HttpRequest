//
//  History.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 25/05/2024.
//

import Foundation
import SwiftData

@Model
final class History: Codable {
    var request: Request

    init(request: Request) {
        self.request = request
    }
    enum CodingKeys: String, CodingKey {
        case request;
    }
    
    init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self);
        
        self.request = try container.decode(Request.self, forKey: .request);
        
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self);
        try container.encode(request, forKey: .request);
    }
    
}
