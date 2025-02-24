//
//  ContentView.swift
//  Alphabet
//
//  Created by Zile Feng on 03/02/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab: Tab = .find
    @State private var selectedCollectionId: UUID? = nil
    @Query private var photoCollections: [PhotoCollection]
    
    var body: some View {
        Group {
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
        .onAppear {
            if selectedCollectionId == nil {
                selectedCollectionId = photoCollections.first?.id
            }
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == .find {
                selectedCollectionId = photoCollections.first?.id
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.previewContainer)
}
