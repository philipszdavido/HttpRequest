//
//  CollectionsView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 08/08/2025.
//

import Foundation
import SwiftUI

struct CollectionsView: View {

    @Environment(\.modelContext) var modelContext
    
    var collections: [Collection]
    
    var body: some View {
        
        ScrollView {
            ForEach(collections) { collection in
                CollectionItemView(collection: collection)
            }
        }

    }
}
