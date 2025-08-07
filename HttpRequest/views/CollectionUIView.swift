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
        } detail: {
            
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
    
    struct FileView: View {
        
        var name: String;
        
        var body: some View {
            
            HStack {
                Text(name)
                Spacer()
                Menu {
                    Button("Rename", action: rename )
                    Button(
                        "Delete",
                        action: delete)
                } label: {
                    Image(systemName: "ellipsis")
                        .imageScale(.large)
                        .padding(6)
                }
                .menuStyle(.button)
                .fixedSize()
            }

        }
        
        func rename() {}
        func delete() {}
        
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
                    
                    Spacer()
                    Menu {
                        Button("Rename", action: rename )
                        Button(
                            "Delete",
                            action: delete)
                    } label: {
                        Image(systemName: "ellipsis")
                            .imageScale(.large)
                            .padding(6)
                    }
                    .menuStyle(.button)
                    .fixedSize()

                    
                }.onTapGesture {
                        show.toggle()
                }
                
                if show {
                    
                    ForEach(collection.items) { fileFolder in
                        if fileFolder.type == .file {
                            if let file = fileFolder.file {
                                FileView(name: file.name)
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
        
        func rename() {}
        func delete() {}

    }
    
    var collections: [Collection]
    
    var body: some View {
        
        ForEach(collections) { collection in
            CollectionItem(collection: collection)
        }

    }
}

struct NewCollectionView: View {

    @Environment(\.modelContext) var modelContext

    @Binding var show: Bool;
    @State var text: String = ""
    
    var body: some View {
        VStack {
                
            Text("Add new collection")
            
            TextField(text: $text) {}
                
            HStack {

                Button("Close") {
                    show.toggle()
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
