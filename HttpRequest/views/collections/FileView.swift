//
//  FileView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 08/08/2025.
//

import Foundation
import SwiftUI

struct FileView: View {

    @Environment(\.modelContext) var modelContext

    var file: File;
    @State var name: String;
    @State var edit = false
    @ObservedObject var clickModel = ClickModel.shared

    var body: some View {
        
        HStack {
            
            if !edit {
                Group {
                    
                    Text(file.request.method)
                        .foregroundStyle(methodColor(method: file.request.method))
                    
                    Text(name)
                    Spacer()
                    Menu {
                        Button("Rename", action: { edit = true; } )
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
                .onTapGesture {
                    clickModel.id = file.id.uuidString
                }
                
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
        .padding(.leading, LEFT_PADDING)
        
        .background(
            clickModel.id == file.id.uuidString ? RoundedRectangle(
                cornerRadius: 6
            )
                .fill(Color.accentColor.opacity(0.3))
            : RoundedRectangle(cornerRadius: 6).fill(Color.clear)
        )
        
        
    }
    
    func rename() {
        
        do {
            
            file.name = name;
            try modelContext.save()
            
            edit = false;
            
        } catch {
            
        }
    }
    func delete() {
        modelContext.delete(file)
    }
    
}
