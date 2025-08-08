//
//  CollectionItemView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 08/08/2025.
//

import Foundation
import SwiftUI

struct CollectionItemView: View {
    @Environment(\.modelContext) var modelContext
    @State var show: Bool = false;
    var collection: Collection
    
    @State var edit = false
    @State var name = ""
    
    @ObservedObject var clickModel = ClickModel.shared
    
    var body: some View {
        VStack {
            HStack {
                
                if !edit {
                    Image(systemName: show ? "chevron.down" : "chevron.right")
                    
                    Image(systemName: "folder")
                    Text(collection.name)
                    
                    Spacer()
                    
                    Menu {
                        Button("Add file", action: addFile )

                        Button("Add folder", action: addFolder )
                        Button("Rename Collection", action: rename )
                        Button(
                            "Delete Collection",
                            action: delete)
                    } label: {
                        Image(systemName: "ellipsis")
                            .imageScale(.large)
                            .padding(6)
                    }
                    .menuStyle(.button)
                    .fixedSize()
                    
                }
                
                if edit {
                    TextField(text: $name) {
                        Text(collection.name)
                    }
                    
                    Button {
                        save()
                    } label: {
                        Text("Save")
                    }
                    
                    Button {
                        edit = false
                    } label: {
                        Text("Cancel").foregroundStyle(.red)
                    }

                }
            }
            .background(
                clickModel.id == collection.id.uuidString ? RoundedRectangle(
                    cornerRadius: 6
                )
                    .fill(Color.accentColor.opacity(0.3))
                            : RoundedRectangle(cornerRadius: 6).fill(Color.clear)
                        )
            .onTapGesture {
                    show.toggle()
                clickModel.id = collection.id.uuidString
            }
            
            if show {
                
                ForEach(collection.items) { fileFolder in
                    if fileFolder.type == .file {
                        if let file = fileFolder.file {
                            FileView(file: file, name: file.name)
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
        .padding(.leading, 2)
    }
    
    func save() {
        do {
            collection.name = name;
            try modelContext.save()
            
            edit = false
        } catch {
            
        }
    }
    
    func rename() {
        edit = true;
    }
    
    func delete() {
        modelContext.delete(collection)
    }
    
    func addFolder() {
        
        let folder = Folder(name: "New folder", items: [])
        let c = CollectionItem(type: .folder, folder: folder, file: nil)
        collection.items += [c]
        
        do {
            //try modelContext.save()
        } catch {}
        
    }
    
    func addFile() {
        
        var request = Request()
        request.method = "GET"
        
        let file = File(name: "New request", request: request)
        
        collection.items += [CollectionItem(type: .file, folder: nil, file: file)]
        
    }


}
