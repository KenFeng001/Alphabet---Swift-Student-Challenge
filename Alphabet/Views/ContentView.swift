//
//  ContentView.swift
//  Alphabet
//
//  Created by Zile Feng on 03/02/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .collection
    @State private var selectedCollectionId: UUID? = SampleData.collection.id
    
    var body: some View {
        if selectedTab == .collection {
            CollectionView(currentTab: selectedTab) { newTab in
                selectedTab = newTab
            }
        } else {
            Current_challenge(
                selectedCollectionId: $selectedCollectionId,
                currentTab: selectedTab
            ) { newTab in
                selectedTab = newTab
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.previewContainer)
}
