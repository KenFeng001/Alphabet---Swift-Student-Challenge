import SwiftUI

struct Navigation: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            Button(action: {
                selectedTab = .collection
            }) {
                HStack {
                    Image(systemName: "photo.on.rectangle")
                        .foregroundColor(.gray)
                    Text("Collection")
                        .foregroundColor(.gray)
                }
            }
              
            // 右侧的图标
            Button(action: {
                selectedTab = .find
            }) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    Text("Finding")
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding(.leading, 20)
        .frame(height: 44)
    }
}

#Preview {
    Navigation(selectedTab: .constant(.collection))
}
