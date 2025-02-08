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
    @State private var selectedLetter: String = "A"
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 相机预览
                GeometryReader { geometry in
                    if let image = model.viewfinderImage {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width - 10, height: geometry.size.width - 10)
                            .cornerRadius(10)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    } else {
                        Color.gray
                            .frame(width: geometry.size.width - 10, height: geometry.size.width - 10)
                            .cornerRadius(10)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                }
                
                // 返回按钮
                VStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.black.opacity(0.5)))
                                .padding(.leading, 20)
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                VStack {
                    Spacer()
                    
                    // 字母选择器
                    letterSelector
                    
                    // 快门按钮
                    shutterButton
                }
            }
            .background(Color.black)
            .ignoresSafeArea()
            .task {
                await model.camera.start()
            }
        }
        .navigationBarHidden(true)
    }
    
    // 抽取字母选择器为单独的视图
    private var letterSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map(String.init), id: \.self) { letter in
                    letterButton(letter)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 60)
        .background(Color.black.opacity(0.5))
    }
    
    // 抽取字母按钮为单独的视图
    private func letterButton(_ letter: String) -> some View {
        Button(action: {
            selectedLetter = letter
        }) {
            Text(letter)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(selectedLetter == letter ? .white : .gray)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(selectedLetter == letter ? Color.blue : Color.white.opacity(0.2))
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
                thumbNailImage: model.thumbnailImage ?? Image("IMG_5719"),
                imageData: model.imageData,
                selectedLetter: selectedLetter
            ),
            isActive: $model.navigateToPreview
        ) {
            EmptyView()
        }
    }
}

#Preview {
    ViewfinderView()
}

