import SwiftUI

struct FinishedCards: View {
    var currentCollection: PhotoCollection

    var body: some View {
        ZStack {
            Image("CongratulationsBG")
                .resizable()
                .scaledToFill()
                .frame(width: 337, height: 449)
            
            VStack(spacing: 0) {
                VStack {
                    Image("CongratulationIcon")

                    Text("Congratulations")
                        .font(.system(size: 24))
                }
                
                ZStack {
                    Image("Celebration")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                    
                    Text("You have found all the letters!")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }
                
                HStack {
                    Image("share")
                }
                .padding(.leading, 140)
                .padding(.top, 30)
            }
        }
        .frame(width: 349, height: 461)
        .clipped()
        .cornerRadius(20)
    }
}

#Preview {
    FinishedCards(currentCollection: SampleData.collection)
}
