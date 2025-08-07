//
//  HistoryView.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 26/06/2025.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    
    @State var selectedHistory: String = "";
    
    @State private var selectedItem: History?
        
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
                }.padding(.vertical, 10)
            }
            
        }
    }
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
        
        HistoryView(
            
        ).onAppear {
            
            var set: Set = [
                History(
                    request: Request(
                    )
                )
            ]
            
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
    }
}

#Preview {
    HistoryView_Preview()
        .modelContainer(for: History.self, inMemory: true)
}
