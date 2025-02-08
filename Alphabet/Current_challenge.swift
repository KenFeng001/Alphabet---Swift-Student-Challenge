//
//  Current_challenge.swift
//  Alphabet
//
//  Created by Zile Feng on 07/02/2025.
//
import SwiftUI
import SwiftData

struct Current_challenge: View {
    var body: some View {
        ScrollView {
            // 主标题
            HStack {
                Text("Collection")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Spacer() // 添加 Spacer 以推送标题到左边
            }
            .padding(.leading) // 可选：添加左侧内边距
            
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
            
            SlidingCards()
                .frame(height: 550) // 给 SlidingCards 一个固定高度
            
            // 添加字母网格
            LetterGrid()
        }
    }
}
    
    
struct Card: View {
    
    var title: String
    var description: String
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
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

        
struct SlidingCards: View {
    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ") // 创建字母数组
    
    var body: some View {
        TabView {
            ForEach(letters.indices, id: \.self) { index in
                Card(title: String(letters[index]), description: "This is the letter \(letters[index]).") // 创建卡片
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always)) // 显示页码指示器
    }
}
    
struct LetterGrid: View {
    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(letters.indices, id: \.self) { index in
                SmallCard(letter: String(letters[index]))
            }
        }
        .padding()
    }
}


struct SmallCard: View {
    let letter: String
    
    var body: some View {
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

