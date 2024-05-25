//
//  MainView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 24/05/2024.
//

import Foundation
import SwiftUI

var index = 0;

struct TabItem: Identifiable {
    var id = index + 1;
    var name: String;
}

struct HistoryItem: Identifiable {
    var id = UUID();
    var name: String;
}

struct MainView: View {
    
    @State private var tabs: [TabItem] = [
    TabItem(name: "POST history")
    ]
    
    @State private var history: [HistoryItem] = [HistoryItem(name: "POST request")]
    
    @State var selectedHistory: String = "";
        
    var body: some View {
        HStack {
            
            Section {
                TabView(selection: $selectedHistory) {
                    List(history) { historyItem in
                        
                        ForEach(1...18, id:\.self) { item in
                            Text(historyItem.name).padding(.vertical, 5.0)
                                .onTapGesture {
                                }
                        }
                        
                    }.tabItem {
                        Text("History")
                    }.tag(1)
                    Text("Collection").tabItem { Text("Collections") }.tag(2)
                }.frame(width: 180)
            }.padding(.all, 4)
            
            Section {
                VStack {
                    HStack {
                        
                        ScrollView(.horizontal, showsIndicators: true) {
                                HStack {
                                    ForEach(tabs) { tab in
                                        HStack {
                                        Text("\(tab.name)")
                                            Image(systemName: "xmark.circle.fill").foregroundStyle(Color.gray).onTapGesture(perform: {
                                            tabs.remove(at: tab.id)
                                        })
                                        }.padding(6)
                                            .border(Color.black, width: 1).cornerRadius(3.0)
                                }
                                
                            }
                        }.padding([.trailing, .top, .leading], 4.0)
                        
                        Image(systemName: "plus.circle.fill")
                            .onTapGesture(perform: {
                                tabs.append(TabItem(name: "Untitled request"))
                            }).padding(.trailing, 4.0)

                        
                    }.padding(.all, 5)
                    Divider()
                    ScrollView {
                        RequestUIView()
                    }.padding(.all, 5)
                    Spacer()
                }
            };
        }
    }
}

#Preview {
    MainView()
        
}
