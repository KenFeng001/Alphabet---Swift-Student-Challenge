import SwiftUI
import SwiftData

// 添加必要的导入
@preconcurrency import UIKit

struct LetterGrid: View {
    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)
    var photoItems: [PhotoItem]
    var currentCollection: PhotoCollection?
    @Binding var showingImagePreview: Bool
    @Binding var selectedPreviewPhotos: [PhotoItem]
    @Binding var selectedPreviewLetter: String
    
    var isStacked: Bool
    var showUnfinished: Bool
    var sortBy: SortOption
    
    // 添加状态来控制相机导航
    @State private var showCamera = false
    @State private var selectedCameraLetter = ""
    
    // 获取所有有照片的字母
    private var lettersWithPhotos: Set<String> {
        Set(photoItems.map { $0.letter })
    }
    
    // 获取字母的最新照片时间
    private func getLatestTimestamp(for letter: String) -> Date {
        let letterPhotos = photoItems.filter { $0.letter == letter }
        return letterPhotos.map { $0.timestamp }.max() ?? .distantPast
    }
    
    // 排序后的字母
    private var sortedLetters: [Character] {
        // 如果只有一张照片，除了那个字母外其他按字母顺序排序
        if photoItems.count == 1 {
            let photoLetter = photoItems[0].letter
            
            // 将有照片的字母放在前面，其他字母按字母顺序排序
            return letters.sorted { letter1, letter2 in
                let str1 = String(letter1)
                let str2 = String(letter2)
                
                if str1 == photoLetter {
                    return true // 有照片的字母排在前面
                }
                if str2 == photoLetter {
                    return false // 有照片的字母排在前面
                }
                return str1 < str2 // 其他字母按字母顺序排序
            }
        }
        
        // 多张照片时按照原来的排序逻辑
        switch sortBy {
        case .time:
            // 按照每个字母最新照片的时间戳排序
            return letters.sorted { letter1, letter2 in
                let timestamp1 = getLatestTimestamp(for: String(letter1))
                let timestamp2 = getLatestTimestamp(for: String(letter2))
                return timestamp1 > timestamp2 // 降序排列，最新的在前
            }
        case .alphabet:
            return letters.sorted() // 字母顺序
        }
    }
    
    // 根据堆叠模式处理照片
    func processPhotos(for letter: String) -> [[PhotoItem]] {
        let letterPhotos = photoItems.filter { $0.letter == letter }
        
        if isStacked {
            // 堆叠模式：所有照片放在一起
            return letterPhotos.isEmpty ? [] : [letterPhotos]
        } else {
            // 非堆叠模式：每张照片单独一组
            return letterPhotos.map { [$0] }
        }
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(sortedLetters.indices, id: \.self) { index in
                let letter = String(sortedLetters[index])
                let processedPhotos = processPhotos(for: letter)
                
                if !processedPhotos.isEmpty || showUnfinished {
                    ForEach(processedPhotos.indices, id: \.self) { photoIndex in
                        SmallCard(
                            letter: letter,
                            photoItems: isStacked ? photoItems : processedPhotos[photoIndex],
                            showingImagePreview: $showingImagePreview,
                            selectedPreviewPhotos: $selectedPreviewPhotos,
                            selectedPreviewLetter: $selectedPreviewLetter,
                            currentCollection: currentCollection,
                            isStacked: isStacked,
                            showUnfinished: showUnfinished,
                            onCameraRequest: { letter in
                                selectedCameraLetter = letter
                                showCamera = true
                            }
                        )
                    }
                    
                    // 如果是非堆叠模式且没有照片，显示一个空卡片
                    if processedPhotos.isEmpty && showUnfinished {
                        SmallCard(
                            letter: letter,
                            photoItems: [],
                            showingImagePreview: $showingImagePreview,
                            selectedPreviewPhotos: $selectedPreviewPhotos,
                            selectedPreviewLetter: $selectedPreviewLetter,
                            currentCollection: currentCollection,
                            isStacked: isStacked,
                            showUnfinished: showUnfinished,
                            onCameraRequest: { letter in
                                selectedCameraLetter = letter
                                showCamera = true
                            }
                        )
                    }
                }
            }
        }
        .padding()
        .navigationDestination(isPresented: $showCamera) {
            ViewfinderView(
                selectedLetter: selectedCameraLetter,
                currentCollection: currentCollection
            )
        }
    }
} 