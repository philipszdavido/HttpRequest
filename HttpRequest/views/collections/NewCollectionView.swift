//
//  NewCollectionView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 08/08/2025.
//

import Foundation
import SwiftUI

struct NewCollectionView: View {

    @Environment(\.modelContext) var modelContext

    @Binding var show: Bool;
    @State var text: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
                
            Text("Add new collection")
                .font(.title)
            
            TextField(text: $text) {
                Text("Type your collection name here...")
            }
                .padding()
                
            HStack {

                Button {
                    show.toggle()
                } label: {
                    Text("Close").foregroundStyle(.red)
                }

                Button("Add") {
                    let col = Collection(name: text)
                    modelContext.insert(col)
                    show = false
                }

            }
        }.padding()
    }
}

#Preview {
    NewCollectionView(show: .constant(false))
        .modelContainer(for: Collection.self, inMemory: true)
}
