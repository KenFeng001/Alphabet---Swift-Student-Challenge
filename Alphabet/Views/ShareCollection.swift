import SwiftUI

struct ShareCollection: View {
    enum Mode {
        case allLetters    // 模式1：所有字母
        case selectedLetters    // 模式2：选定字母
    }
    
    let collection: PhotoCollection
    @State private var mode: Mode = .allLetters
    @State private var selectedLetters: Set<String> = []
    @State private var generatedImage: UIImage?
    
    var body: some View {
        VStack {
            // 模式选择器
            Picker("分享模式", selection: $mode) {
                Text("所有字母").tag(Mode.allLetters)
                Text("选择字母").tag(Mode.selectedLetters)
            }
            .pickerStyle(.segmented)
            .padding()
            
            if mode == .selectedLetters {
                // 字母选择网格
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6)) {
                    ForEach(collection.collectedLetters.sorted(), id: \.self) { letter in
                        LetterSelectButton(
                            letter: letter,
                            isSelected: selectedLetters.contains(letter),
                            action: {
                                if selectedLetters.contains(letter) {
                                    selectedLetters.remove(letter)
                                } else {
                                    selectedLetters.insert(letter)
                                }
                            }
                        )
                    }
                }
                .padding()
            }
            
            // 预览区域
            if let image = generatedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            
            // 生成按钮
            Button(action: generateImage) {
                Text("生成分享图")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
    
    private func generateImage() {

    }
}

// 字母选择按钮组件
struct LetterSelectButton: View {
    let letter: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(letter)
                .font(.system(size: 20, weight: .medium))
                .frame(width: 40, height: 40)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(8)
        }
    }
}

struct ShareCollectionSheet: View {
    @Environment(\.dismiss) private var dismiss
    let collection: PhotoCollection
    
    var body: some View {
        NavigationStack {
            ShareCollection(collection: collection)
                .navigationTitle("分享集合")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("取消") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

#Preview {
    ShareCollection(collection: SampleData.collection)
}
