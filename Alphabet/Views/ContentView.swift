//
//  ContentView.swift
//  Alphabet
//
//  Created by Zile Feng on 03/02/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .collection
    
    var body: some View {
        if selectedTab == .collection {
            Navigation(selectedTab: $selectedTab)
            CollectionView()
        } else {
            Navigation(selectedTab: $selectedTab)
            Current_challenge()
        }

    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.previewContainer)
}
