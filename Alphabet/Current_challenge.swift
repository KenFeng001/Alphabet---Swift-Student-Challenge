//
//  Current_challenge.swift
//  Alphabet
//
//  Created by Zile Feng on 07/02/2025.
//
import SwiftUI
import SwiftData

struct Current_challenge: View {
    @Query private var photoItems: [PhotoItem]
    
    var body: some View {
        ScrollView {
            // 主标题和相机按钮
            HStack {
                Text("Collection")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
                
                // 添加相机按钮
                NavigationLink(destination: ViewfinderView()) {
                    Image(systemName: "camera.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Circle().fill(Color.blue.opacity(0.2)))
                }
                .padding(.trailing)
            }
            .padding(.leading)
            
            // 二级标题和进度条
            HStack {
                Text("Progress")
                    .font(.headline)
                    .padding(.trailing)
                
                ProgressView(value: 1, total: 26) // 进度条，设置为50%
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 200) // 设置进度条宽度
            }
            .padding(.leading)
            
            SlidingCards(photoItems: photoItems)
                .frame(height: 550) // 给 SlidingCards 一个固定高度
            
            // 添加字母网格
            LetterGrid(photoItems: photoItems)
        }
    }
}
    
    
struct Card: View {
    var title: String
    var description: String
    var photoItems: [PhotoItem]  // 通过属性传递，而不是使用 @Query

    var body: some View {
        if let matchingItem = photoItems.first(where: { $0.letter == title }),
           let uiImage = UIImage(data: matchingItem.imageData) {
            // 将 Data 转换为 UIImage，然后创建 SwiftUI Image
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: 337, height: 449)
                .background(Color.gray)
                .cornerRadius(20)
                .shadow(radius: 10)
        } else {
            VStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Text(description)
                    .font(.body)
                    .padding()
            }
            .frame(width: 337, height: 449)
            .background(Color.gray)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}

        
struct SlidingCards: View {
    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    var photoItems: [PhotoItem]  // 通过属性传递
    
    var body: some View {
        TabView {
            ForEach(letters.indices, id: \.self) { index in
                Card(
                    title: String(letters[index]),
                    description: "This is the letter \(letters[index]).",
                    photoItems: photoItems
                )
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always)) // 显示页码指示器
    }
}
    
struct LetterGrid: View {
    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)
    var photoItems: [PhotoItem]  // 通过属性传递
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(letters.indices, id: \.self) { index in
                SmallCard(
                    letter: String(letters[index]),
                    photoItems: photoItems
                )
            }
        }
        .padding()
    }
}


struct SmallCard: View {
    let letter: String
    var photoItems: [PhotoItem]  // 通过属性传递，而不是使用 @Query
    
    var body: some View {
        if let matchingItem = photoItems.first(where: { $0.letter == letter }),
           let uiImage = UIImage(data: matchingItem.imageData) {
            // 如果找到匹配的图片，显示图片
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .background(Color.gray)
                .cornerRadius(10)
        } else {
            // 如果没有找到图片，显示字母
            VStack {
                Text(letter)
                    .font(.title)
                    .fontWeight(.bold)
            }
            .frame(width: 100, height: 100)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
    }
}

