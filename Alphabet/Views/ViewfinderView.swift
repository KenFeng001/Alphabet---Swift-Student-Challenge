////  ViewfinderView.swift
//  Alphabet
//
//  Created by Zile Feng on 03/02/2025.
//

import SwiftUI

struct ViewfinderView: View {
    @StateObject var model = DataModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var selectedLetter: String
    var currentCollection: PhotoCollection?
    @State private var zoomText: String = "1x"  // 添加状态变量
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // 顶部当前选中的字母显示
                Text(selectedLetter)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)                
                
                // 相机预览
                if let image = model.viewfinderImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(3/4, contentMode: .fit)
                        .cornerRadius(20)
                        .padding(.horizontal, 40)
                } else {
                    Color.gray
                        .aspectRatio(3/4, contentMode: .fit)
                        .cornerRadius(20)
                        .padding(.horizontal, 40)
                }
                
                letterSelector
                
                // 底部控制栏
                HStack(spacing: 30) {
                    // 返回按钮
                    Button(action: {
                        dismiss()
                    }) {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            )
                    }
                    
                    // 快门按钮
                    Button(action: {
                        Task { @MainActor in
                            model.camera.takePhoto()
                        }
                    }) {
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: 65, height: 65)
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                    .background(navigationLink)
                    
                    // 缩放按钮
                    Button(action: {
                        model.camera.toggleZoom()
                        zoomText = model.camera.zoomDescription
                    }) {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Text(zoomText)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                            )
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .ignoresSafeArea()
            .task {
                await model.camera.start()
            }
        }
        .navigationBarHidden(true)
    }
    
    // 修改字母选择器视图
    private var letterSelector: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map(String.init), id: \.self) { letter in
                        letterButton(letter)
                            .id(letter)
                    }
                }
                .padding(.horizontal, UIScreen.main.bounds.width / 2 - 25)
            }
            .frame(height: 50)
            .background(Color.clear)
            .onChange(of: selectedLetter) { newValue in
                withAnimation {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
    
    // 修改字母按钮视图
    private func letterButton(_ letter: String) -> some View {
        Button(action: {
            selectedLetter = letter
        }) {
            Text(letter)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(selectedLetter == letter ? .white : .gray)
                .frame(width: 35, height: 35)
                .background(
                    Circle()
                        .fill(selectedLetter == letter ? Color.white.opacity(0.3) : Color.clear)
                )
        }
    }
    
    // 抽取快门按钮和导航链接为单独的视图
    private var shutterButton: some View {
        Button(action: {
            Task { @MainActor in
                model.camera.takePhoto()
            }
        }) {
            Circle()
                .stroke(Color.white, lineWidth: 3)
                .frame(width: 65, height: 65)
                .background(Circle().fill(Color.white.opacity(0.2)))
                .padding(.bottom, 30)
                .padding(.top, 10)
        }
        .background(navigationLink)
    }
    
    // 抽取导航链接为单独的视图
    private var navigationLink: some View {
        NavigationLink(
            destination: ViewfinderImagePreview(
                thumbNailImage: model.thumbnailImage ?? Image(systemName: "photo"),
                imageData: model.imageData,
                selectedLetter: selectedLetter,
                currentCollection: currentCollection
            ),
            isActive: $model.navigateToPreview
        ) {
            EmptyView()
        }
    }
}

#Preview {
    ViewfinderView(selectedLetter: "A")
}

