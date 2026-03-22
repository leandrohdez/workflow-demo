//
//  ContentView.swift
//  workflow_demo
//
//  Created by Leandro Hernandez on 22/3/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)

            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: selectedTab == 1 ? "square.grid.2x2.fill" : "square.grid.2x2")
                }
                .tag(1)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: selectedTab == 2 ? "person.fill" : "person")
                }
                .tag(2)
        }
        .tint(.blue)
    }
}

#Preview {
    ContentView()
}
