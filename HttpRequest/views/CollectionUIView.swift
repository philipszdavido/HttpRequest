//
//  CollectionUIView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 31/05/2024.
//

import SwiftUI
import SwiftData

struct CollectionUIView: View {
    
    @State var show = false
    @Query var collections: [Collection]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Button("Add") {
                let col = Collection(name: "New collection")
                modelContext.insert(col)
            }
            
            CollectionsView(collections: collections)
            
            Spacer()

        }.sheet(isPresented: $show) {
            VStack {
                HStack {
                    Text("Hello")
                    
                    Button("Close") {
                        show.toggle()
                    }

                }
            }
        }
        .frame(maxWidth: .infinity)
        
        
    }
        
}

struct CollectionUIView_Preview: View {

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        
        CollectionUIView().onAppear {
            
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

            var request = Request()
            request.url = urls.randomElement() ?? ""
            
            request.method = methods.randomElement() ?? ""

            for _ in 0..<3 {
                
                let item = CollectionItem(
                    type: CollectionItemType.file,
                    file: File(name: "GET request", request: request)
                );
                
                let collection = Collection(
                    name: "Swift Collection",
                    items: [item]
                );

                modelContext.insert(collection)
                
            }
            
        }
    }
}

#Preview {
    CollectionUIView_Preview()
        .modelContainer(for: Collection.self, inMemory: true)
}


struct CollectionsView: View {
    
    struct FolderView: View {
        
        @State var show: Bool = false;
        var folder: Folder;
        
        var body: some View {
            
            HStack {
                
                Image(systemName: show ? "chevron.down" : "chevron.right")
                
                Image(systemName: "folder")
                Text(folder.name)
            }.onTapGesture {
                show.toggle()
            }
            
            if show {
                ForEach(folder.items) { fileFolder in
                    
                    if fileFolder.type == .file {
                        if let file = fileFolder.file {
                            Text(file.name)
                        }
                    }
                    
                    if fileFolder.type == .folder {
                        if let folder = fileFolder.folder {
                            FolderView(folder: folder)
                        }
                    }
                    
                }
            }
        }
    }
    
    struct CollectionItem: View {
        
        @State var show: Bool = false;
        var collection: Collection
        
        var body: some View {
            VStack {
                HStack {
                    
                    Image(systemName: show ? "chevron.down" : "chevron.right")

                    Image(systemName: "folder")
                    Text(collection.name)
                    
                }.onTapGesture {
                        show.toggle()
                }
                
                if show {
                    
                    ForEach(collection.items) { fileFolder in
                        if fileFolder.type == .file {
                            if let file = fileFolder.file {
                                Text(file.name).padding()
                            }
                        }
                        
                        if fileFolder.type == .folder {
                            if let folder = fileFolder.folder {
                                FolderView(folder: folder)
                            }
                        }
                        
                    }
                    
                }
                
           }
        }
    }
    
    var collections: [Collection]
    
    var body: some View {
        
        ForEach(collections) { collection in
            CollectionItem(collection: collection)
        }//.listStyle(.plain)

    }
}
