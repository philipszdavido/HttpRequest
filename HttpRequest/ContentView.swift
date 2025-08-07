
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
    
    @State private var selectedTab: String = ""
        
    var body: some View {

        NavigationSplitView {
            
            Section {
                TabView {
                    
                    HistoryView().tabItem {
                        Text("History")
                    }.tag(1)
                                        
                    CollectionUIView()
                        .tabItem {
                            Text("Collections")
                    }.tag(2)
                    
                    Text("Env")
                        .tabItem {
                            Text("Env")
                        }
                        .tag(3)
                    
                }.frame(width: .infinity)
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
                // modelContext.delete(histories[index])
            }
        }
    }

}

struct TabButton: View {
    
    var tab: TabItem
    @Binding var tabs: [TabItem]
    var selectedTab = false
    @State private var showXmar = false
    
    var body: some View {
        HStack(alignment: .center) {
            
            Text("\(tab.name)")
            Spacer().frame(width: 20)

            if showXmar {
                Image(systemName: "xmark.circle.fill").foregroundStyle(Color.gray).onTapGesture(perform: {
                    tabs.remove(at: tab.id)
                })
            }

            Rectangle().foregroundColor(.gray).frame(width: 1.0, height: 10)

        }
        .padding(6)
        .onHover { event in
            showXmar = event
        }
        
    }
}

struct ContentView_Preview: View {
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
        ContentView()
            .modelContainer(for: [History.self, Collection.self], inMemory: true)
        
            .onAppear {
                
                var set: Set = [
                    History(
                        request: Request()
                    )
                ]
                
                for _ in 0..<3 {
                    
                    var request = Request()
                    request.url = urls.randomElement() ?? ""
                    
                    request.method = methods.randomElement() ?? ""
                    modelContext.insert(
                        History( request: request )
                    )
                }
                
            }
    }
}

#Preview {
    ContentView_Preview()
        .modelContainer(for: [History.self, Collection.self], inMemory: true)
}

