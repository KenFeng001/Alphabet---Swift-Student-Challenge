import SwiftUI

struct Navigation: View {
    var currentTab: Tab
    var onTabChange: (Tab) -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                onTabChange(.collection)
            }) {
                HStack {
                    Image(systemName: "photo.on.rectangle")
                        .foregroundColor(currentTab == .collection ? .black : .gray)
                    Text("Collection")
                        .foregroundColor(currentTab == .collection ? .black : .gray)
                        .fontWeight(currentTab == .collection ? .bold : .regular)
                }
            }
              
            // Right side icon
            Button(action: {
                onTabChange(.find)
            }) {
                HStack {
                    Image(systemName: "character.magnify")
                        .foregroundColor(currentTab == .find ? .black : .gray)
                    Text("Finding")
                        .foregroundColor(currentTab == .find ? .black : .gray)
                        .fontWeight(currentTab == .find ? .bold : .regular)
                }
            }
            Spacer()
        }
        .padding(.leading, 20)
        .frame(height: 44)
    }
}

#Preview {
    Navigation(currentTab: .collection) { _ in }
}
