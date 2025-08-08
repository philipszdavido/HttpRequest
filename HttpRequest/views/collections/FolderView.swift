//
//  FolderView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 08/08/2025.
//

import Foundation
import SwiftUI

struct FolderView: View {

    @Environment(\.modelContext) var modelContext

    @State var show: Bool = false;
    var folder: Folder;
    @State var edit = false
    @State var name = ""
    @ObservedObject var clickModel = ClickModel.shared

    var body: some View {
        
        VStack {
            HStack {
                
                if !edit {
                    
                    Image(systemName: show ? "chevron.down" : "chevron.right")
                    Image(systemName: "folder")
                    Text(folder.name)
                    
                    Spacer()
                    
                    Menu {
                        Button("Add file", action: addFile )
                        Button("Add folder", action: addFolder )
                        Button(
                            "Rename",
                            action: { name = folder.name; edit = true;
                            } )
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
                    
                } else {
                    
                    TextField(text: $name) {
                        Text(name)
                    }
                    
                    Button {
                        rename()
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
            .onTapGesture {
                show.toggle()
            }

            if show {
                ForEach(folder.items) { fileFolder in
                    
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
        .padding(.leading, LEFT_PADDING)
        .background(
            clickModel.id == folder.id.uuidString ? RoundedRectangle(
                cornerRadius: 6
            )
            .fill(Color.accentColor.opacity(0.3))
            : RoundedRectangle(cornerRadius: 6).fill(Color.clear)
        )
                    
    }
    
    func rename() {
        
        do {
            
            folder.name = name;
            // try modelContext.save()
            edit = false
            
        } catch {
            
        }
    }
    
    func delete() {
        modelContext.delete(folder)
        edit = false
    }
    
    func addFolder() {
        
        let folder = Folder(name: "New folder", items: [])
        let c = CollectionItem(type: .folder, folder: folder, file: nil)
        folder.items += [c]
        
//        do {
//            try modelContext.save()
//        } catch {}
        
    }
    
    func addFile() {
        
        var request = Request()
        request.method = "GET"
        
        let file = File(name: "New request", request: request)
        
        folder.items += [CollectionItem(type: .file, folder: nil, file: file)]
        
    }

}

#Preview {
    FolderView(folder: Folder(name: "New folder", items: []))
        .modelContainer(
            for: [Collection.self, Folder.self, File.self],
            inMemory: true
        )
}
