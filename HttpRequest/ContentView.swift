
//
//  MainView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 24/05/2024.
//

import Foundation
import SwiftUI
import SwiftData

var index = 0;

struct TabItem: Identifiable {
    var id = index + 1;
    var name: String;
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var tabs: [TabItem] = [
        TabItem(name: "POST history")
    ]
        
    @State var selectedHistory: String = "";
    
    @State private var selectedItem: History?
    
    @Query private var histories: [History]
    
    @State private var selection = Set<History>()
    
        
    var body: some View {
        //HStack {
        NavigationSplitView {
            
            Section {
                TabView(selection: $selectedHistory) {
                    List(histories, selection: $selection) { history in
                        
                        NavigationLink {
                            RequestUIView()
                        } label: {
                            Text(history.request.url)
                        }
                        
                    }.tabItem {
                        Text("History")
                    }.tag(1)
                    
                    Text("Collection").tabItem { Text("Collections")
                    }.tag(2)
                    
                }.frame(width: 180)
            }.padding(.all, 4)
            
            
        } detail: {
            Section {
                VStack {
                    HStack {
                        
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack {
                                ForEach(tabs) { tab in
                                    TabButton(tab: tab, tabs: $tabs)
                                }
                                
                            }
                        }.padding([.trailing, .top, .leading], 4.0)
                                                
                    }
                    Divider()
                    ScrollView {
                        RequestUIView()
                    }.padding([.trailing, .leading], 10)
                    Spacer()
                }
            };
        }.toolbar {
            ToolbarItem {
                Button(action: {
                    tabs.append(TabItem(name: "Untitled request"))
                }) {
                    Label("Add Item", systemImage: "plus")
                }
            }

        }
        
            
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(histories[index])
            }
        }
    }

}


#Preview {
    ContentView()
        .modelContainer(for: History.self, inMemory: true)
        
}

struct TabButton: View {
    
    var tab: TabItem
    @Binding var tabs: [TabItem]
    
    var body: some View {
        HStack {
            Text("\(tab.name)")
            Image(systemName: "xmark.circle.fill").foregroundStyle(Color.gray).onTapGesture(perform: {
                tabs.remove(at: tab.id)
            })
        }.padding(6)
            .border(Color.black, width: 1).cornerRadius(3.0)
    }
}
