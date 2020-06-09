//
//  ContentView.swift
//  testMasterDetail
//
//  Created by Miguel de Icaza on 4/25/20.
//  Copyright © 2020 Miguel de Icaza. All rights reserved.
//

import SwiftUI

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct ContentView: View {
    @State var dates = [Date]()
    
    var body: some View {
        NavigationView {
            HomeView(dates: $dates)
                .navigationBarTitle(Text("SwiftTerm"))
            DetailView()
        }//.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct QuickLaunch: View {
    @State var quickCommand: String = ""
    
    func go () {
        guard quickCommand.count > 0 else { return }
        let sp1 = quickCommand.split (separator: ":")
        let sp2 = sp1.split (separator: "@")
//        let user, host: String
//        if sp2.count == 1 {
//            host = String (sp2 [0])
//            user = ""
//        } else {
//            user = String (sp2 [0])
//            host = String (sp2 [1])
//        }
        let port = sp1.count > 1 ? Int (String (sp1 [1])) ?? 22 : 22
        
    }
    var body: some View {
        HStack {
            
            TextField("user@hostname:22", text: $quickCommand)
            Button(action: {}) {
                Text ("Connect")
            }
        }
    }
}
struct HomeView: View {
    @ObservedObject var store: DataStore = DataStore.shared
    @ObservedObject var connections = Connections.shared
    
    @Binding var dates: [Date]

    func sortDate (first: Host, second: Host) throws -> Bool
    {
        first.lastUsed > second.lastUsed
    }
    
    var body: some View {
        List {
            QuickLaunch()
            //ConnectionSummaryView()
            Section (header: Text ("Recent")) {
                ForEach(self.store.recentIndices (), id: \.self) { idx in
                    HostSummaryView (host: self.$store.hosts [idx])
                }
            }
            Section {
                NavigationLink(
                    destination: HostsView()
                ) {
                    Text("Hosts")
                }
                NavigationLink(
                    destination: SessionsView()
                ) {
                    Text("Sessions")
                    Spacer()
                    Text ("\(connections.connections.count)")
                        .padding(4)
                        .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
                        .cornerRadius(3)
                        .foregroundColor(Color(#colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)))
                }
                NavigationLink(
                    destination: KeyManagementView( )
                ) {
                    Text("Keys")
                }
                NavigationLink(
                    destination: SettingsView()
                ) {
                    Text("Settings")
                }
            }
        }.listStyle(GroupedListStyle())
    }
}

struct DetailView: View {
    var body: some View {
        Group {
            Text("Detail view content goes here")
        }.navigationBarTitle(Text("Detail"))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
