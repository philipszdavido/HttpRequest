//
//  HistoryView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 26/06/2025.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State var show: Bool = false;

    @State var selectedHistory: History?
            
    @State private var selection = Set<History>()

    @Query private var histories: [History]

    var body: some View {
        List(histories, selection: $selection) { history in
            
            NavigationLink {
                RequestUIView()
            } label: {
                
                HStack {
                    Text(history.request.method)
                        .foregroundStyle(methodColor(method: history.request.method))
                    Text(history.request.url)
                    
                    Spacer()
                    
                    MenuHistoryView(history: history)
                    
                }
                .padding(.vertical, 10)
                    .contentShape(Rectangle())
                
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
        
}

struct MenuHistoryView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State var show: Bool = false;

    var history: History;
    
    var body: some View {
        Menu {
            Button("Add to collection", action: addToCollection )
            Button(
                "Delete",
                action: deleteHistory)
        } label: {
            Image(systemName: "ellipsis")
                .imageScale(.large)
                .padding(6)
        }
        .menuStyle(.button)
        .fixedSize()
        
        .sheet(isPresented: $show) {
            SaveToCollectionView(
                history: history,
                cancelAction: {
                    show = false;
                }
            )
        }
        
        
    }
    
    func addToCollection() {
        withAnimation {
            show = true;
        }
    }
    
    func deleteHistory() {
        withAnimation {
            modelContext.delete(history);
        }
    }

}

struct SaveToCollectionView: View {

    @Environment(\.modelContext) private var modelContext

    @Query private var collections: [Collection]
    
    @State private var selectedCollection: Collection?
    @State private var title: String = ""
    
    var history: History;
    var cancelAction: () -> Void

    var body: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            HStack {
                Text("Save to collection")
                    .font(.title)
            }
            
            TextField(text: $title) {}
            
            GroupBox(label:
                    Label("All Collections", systemImage: "building.columns")
            ) {
                ForEach(collections) { collection in
                    HStack {
                        Image(systemName: "folder")
                        Text(collection.name)
                    }
                    .padding()
                    .background(
                        collection.id.uuidString == selectedCollection?.id.uuidString ? .blue : .yellow
                    )
                    .onTapGesture {
                        selectedCollection = collection;
                    }
                }
            }
            
            HStack {
                Button {
                    cancelAction()
                } label: {
                    Text("Cancel").foregroundStyle(.red)
                }
                
                Button {
                    saveAction()
                } label: {
                    Text("Save")
                }
                
            }
        }.padding()
    }
    
    func saveAction() {
        if let collection = selectedCollection {
            
            let request = history.request;
            let c = CollectionItem(
                type: CollectionItemType.file,
                file: File(name: title, request: request)
            )
            collection.items += [c]
            do {
                try modelContext.save()
            } catch {
                print(error)
            }
            cancelAction()
        }
    }
}

#Preview {
    SaveToCollectionView(history: History(request: Request()), cancelAction: {})
        .modelContainer(for: Collection.self, inMemory: true)
        .frame(width: 400, height: 100)
}

struct HistoryView_Preview: View {

    @Environment(\.modelContext) private var modelContext
    @State private var selection = Set<History>()
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

    var body: some View {
        
            NavigationSplitView {
                HistoryView(
                    
                ).onAppear {
                    
                    var _: Set = [ History(request: Request()) ]
                    
                    for _ in 0..<3 {
                        
                        var request = Request()
                        request.url = urls.randomElement() ?? ""
                        
                        request.method = methods.randomElement() ?? ""
                        modelContext.insert(History(
                            request: request
                        )
                        )
                    }
                    
                }
            } detail: {
                
            }
        }
    
}

#Preview {
    HistoryView_Preview()
        .modelContainer(for: History.self, inMemory: true)
}
