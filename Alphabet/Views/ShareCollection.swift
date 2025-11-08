import SwiftUI

struct ShareCollection: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedOption = 0 // 0: all letters, 1: typed letters
    @State private var typedText = ""
    @FocusState private var isTextFieldFocused: Bool  // 改用 FocusState
    @State private var navigateToStitch = false
    var stichedCollection:PhotoCollection
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Back button
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.blue)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                
                // Title and description
                VStack(spacing: 8) {
                    Text("Stictch your collection and share it with your friends!")
                        .font(.title2)
                        .fontWeight(.semibold)
                    

                }
                .padding(.horizontal, 24)
                
                // Options
                VStack(spacing: 16) {
                    // Option 1
                    Button {
                        selectedOption = 0
                        isTextFieldFocused = false  // Cancel text field focus when selecting option 1
                    } label: {
                        HStack {
                            Text("Stitch all the letters")
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedOption == 0 {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    // Option 2
                    Button {
                        selectedOption = 1
                        isTextFieldFocused = true  // Focus text field when selecting option 2
                    } label: {
                        HStack {
                            Text("Stitch typed letters")
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedOption == 1 {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    // Text field
                    if selectedOption == 1 {
                        TextEditor(text: $typedText)
                            .frame(height: 100)  // Set fixed height
                            .multilineTextAlignment(.center)
                            .focused($isTextFieldFocused)  // Use FocusState
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .padding(.horizontal, 2)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                
                // Continue button
                Button {
                    navigateToStitch = true
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .background(Color(uiColor: .systemBackground))
            .navigationDestination(isPresented: $navigateToStitch) {
                StitchImage(
                    isAllLetters: selectedOption == 0,
                    typedText: typedText,
                    stichedCollection: stichedCollection
                )
            }
        }
    }
}

#Preview {
    ShareCollection(stichedCollection: SampleData.collection)
}
