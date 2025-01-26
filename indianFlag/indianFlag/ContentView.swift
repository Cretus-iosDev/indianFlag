import SwiftUI

// MARK: - ViewModel
class FlagViewModel: ObservableObject {
    @Published var waveOffset: CGFloat = 0.0
    @Published var textAnimationTrigger: Bool = false
    
    func startWaveAnimation() {
        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
            waveOffset = .pi * 2
        }
    }
    
    func startTextAnimation() {
        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            textAnimationTrigger = true
        }
    }
}

// MARK: - View
struct IndianFlagView: View {
    @StateObject private var viewModel = FlagViewModel()
    
    var body: some View {
        VStack {
            Spacer() // Push content towards the center
            
            // Flag and Pole
            HStack(alignment: .top, spacing: 0) {
                // Pole
                Rectangle()
                    .fill(Color.brown)
                    .frame(width: 12, height: 400)
                
                // Flag
                WavingFlagShape(offset: viewModel.waveOffset)
                    .stroke(Color.black.opacity(0.1), lineWidth: 1) // Border for the flag
                    .background(
                        FlagColors()
                            .clipShape(WavingFlagShape(offset: viewModel.waveOffset))
                    )
                    .frame(width: 280, height: 180)
                    .shadow(radius: 4)
                    .offset(y: 0) // Place the flag properly at the top
            }
            .frame(height: 400) // Adjust pole height
            
            // Republic Day Message with Animation
            Text("🇮🇳 Happy Republic Day 🇮🇳")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(Color.white)
                .scaleEffect(viewModel.textAnimationTrigger ? 1.1 : 1.0) // Scale animation
                .opacity(viewModel.textAnimationTrigger ? 1.0 : 0.7) // Fade animation
                .onAppear {
                    viewModel.startTextAnimation()
                }
                .padding(.top, 20)
            
            Spacer() // Push content towards the center
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Take up full screen
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.orange, Color.white, Color.green]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            viewModel.startWaveAnimation()
        }
    }
}

// MARK: - Flag Colors
struct FlagColors: View {
    var body: some View {
        VStack(spacing: 0) {
            // Top Band (Saffron)
            Rectangle()
                .fill(Color.orange)
            
            // Middle Band (White with Ashoka Chakra)
            ZStack {
                Rectangle()
                    .fill(Color.white)
                AshokaChakra()
                    .frame(width: 50, height: 50)
            }
            
            // Bottom Band (Green)
            Rectangle()
                .fill(Color.green)
        }
    }
}

// MARK: - Flag Shape
struct WavingFlagShape: Shape {
    var offset: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let waveHeight: CGFloat = 10
        let waveLength: CGFloat = rect.width / 3
        
        path.move(to: .zero)
        
        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX = x / waveLength
            let sineY = sin(relativeX * .pi * 2 - offset) * waveHeight
            path.addLine(to: CGPoint(x: x, y: rect.minY + sineY))
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.maxY))
        
        for x in stride(from: rect.width, through: 0, by: -1) {
            let relativeX = x / waveLength
            let sineY = sin(relativeX * .pi * 2 - offset) * waveHeight
            path.addLine(to: CGPoint(x: x, y: rect.maxY + sineY))
        }
        
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.closeSubpath()
        return path
    }
    
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
}

// MARK: - Ashoka Chakra
struct AshokaChakra: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.blue, lineWidth: 4)
            
            ForEach(0..<24) { tick in
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 2, height: 15)
                    .offset(y: -25)
                    .rotationEffect(.degrees(Double(tick) * 360 / 24))
            }
        }
    }
}

// MARK: - ContentView
struct ContentView: View {
    var body: some View {
        IndianFlagView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
