//
//  CollectionUIView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 31/05/2024.
//

import SwiftUI
import SwiftData

let LEFT_PADDING: CGFloat = 20;

struct CollectionUIView: View {
    
    @State var show = false
    @Query var collections: [Collection]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Button("Add") {
                    show = true
                }
                
                CollectionsView(collections: collections)
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .sheet(isPresented: $show) {
            NewCollectionView(show: $show)
        }
        
    }
        
}

struct CollectionUIView_Preview: View {

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationSplitView {
            
            CollectionUIView()
                .frame(width: 300)
                .onAppear {
                    
                    let urls = [
                        "https://google.com",
                        "https://cnn.com",
                        "https://bbc.com"
                    ]
                    
                    let methods = [
                        "get",
                        "put",
                        "post",
                        "delete",
                        "options"
                    ]
                                        
                    for index in 0..<3 {
                        var request = Request()
                        request.url = urls.randomElement() ?? ""
                        
                        request.method = methods.randomElement() ?? ""

                        let item = CollectionItem(
                            type: CollectionItemType.file,
                            file: File(name: "GET request", request: request)
                        );
                        
                        let collection = Collection(
                            name: "Swift Collection " + index.description,
                            items: [item]
                        );
                        
                        modelContext.insert(collection)
                        
                    }
                    
                }
        } detail: {
            
        }
    }
}

#Preview {
    CollectionUIView_Preview()
        .modelContainer(for: Collection.self, inMemory: true)
}
