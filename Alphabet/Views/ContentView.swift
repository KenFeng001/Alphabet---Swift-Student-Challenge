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
            Navigation(selectedTab: $selectedTab)
            CollectionView()
        } else {
            Navigation(selectedTab: $selectedTab)
            Current_challenge(selectedCollectionId: $selectedCollectionId)
        }

    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.previewContainer)
}
