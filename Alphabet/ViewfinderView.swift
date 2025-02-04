//
//  ViewfinderView.swift
//  Alphabet
//
//  Created by Zile Feng on 03/02/2025.
//

import SwiftUI

struct ViewfinderView: View {
    @StateObject var model = DataModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 相机预览
            GeometryReader { geometry in
                if let image = model.viewfinderImage {
                        image.resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width-10, height: geometry.size.width-10)
                            .position(x: geometry.size.width/2, y: geometry.size.height/2)
                            .cornerRadius(50)
                }
                else {
                    Text("Image not available")
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
            
            // 快门按钮
            VStack {
                Spacer()
                Button(action: {
                    model.camera.takePhoto()
                }) {
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 65, height: 65)
                        .background(Circle().fill(Color.white.opacity(0.2)))
                        .padding(.bottom, 30)
                }
            }
        }
        .background(Color.black)
        .ignoresSafeArea()
        .task {
            await model.camera.start()
        }
    }
}

#Preview {
    ViewfinderView(model: DataModel())
}
