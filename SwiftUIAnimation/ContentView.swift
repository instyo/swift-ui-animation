//
//  ContentView.swift
//  SwiftUIAnimation
//
//  Created by Hidayat Abisena on 06/12/22.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTIES
   
    
    // MARK: - BODY
    var body: some View {
        ScrollView {
            ScaleEffectAnimationView()
            LoadingView()
            LoadingProgressView()
            DotLoadingView()
            MorphingAnimationView()
        } //: SCROLLVIEW
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - SCALE EFFECT
struct ScaleEffectAnimationView: View {
    @State private var circleColorChanged: Bool = false
    @State private var carColorChanged: Bool = false
    @State private var carSizeChanged: Bool = false
    
    let firstGradient = LinearGradient(colors: [Color.red, Color.yellow], startPoint: .center, endPoint: .bottomTrailing)
    
    let secondGradient = LinearGradient(colors: [Color.purple, Color.indigo], startPoint: .top, endPoint: .center)
    
    var body: some View {
        ZStack {
            Circle()
                .fill(circleColorChanged ? firstGradient : secondGradient)
                .frame(width: 200, height: 200)
                .animation(.easeIn, value: circleColorChanged)
            
            Image(systemName: "bolt.car.fill")
                .foregroundColor(carColorChanged ? .yellow : .white)
                .font(.system(size: 100))
                .scaleEffect(carSizeChanged ? 1.0 : 0.5)
                .animation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.3), value: circleColorChanged)
            
        } //: ZSTACK
        .onTapGesture {
            circleColorChanged.toggle()
            carColorChanged.toggle()
            carSizeChanged.toggle()
        }
    }
}

struct LoadingView: View {
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 14)
                .frame(width: 100, height: 100)
            
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(Color.purple, lineWidth: 7)
                .frame(width: 100, height: 100)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .onAppear {
                    
                    let baseAnimation = Animation.linear(duration: 1.0)
                    let repeated = baseAnimation.repeatForever(autoreverses: false)
                    
                    withAnimation(repeated) {
                        isLoading = true
                    }
                }
        } //: ZSTACK
        .padding()
    }
}

struct LoadingProgressView: View {
    @State private var progress: CGFloat = 0.0
    @State private var isLoadingProgress: Bool = false
    
    var body: some View {
        ZStack {
            Text("\(Int(progress*100))%")
            
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 10)
                .frame(width: 150, height: 150)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.purple, lineWidth: 10)
                .frame(width: 150, height: 150)
                .rotationEffect(Angle(degrees: -90))
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                        progress += 0.05
                        if progress >= 1.0 {
                            timer.invalidate()
                        }
                        
                    }
                }
        } //: ZSTACK
        .padding()
    }
}

struct DotLoadingView: View {
    @State private var isDotLoading: Bool = false
    
    var body: some View {
        HStack {
            ForEach(0...4, id: \.self) { item in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(.green.gradient)
                    .scaleEffect(isDotLoading ? 0 : 1)
                    .animation(.linear(duration: 0.6).repeatForever().delay(0.2 * Double(item)), value: isDotLoading)
            }
            .onAppear {
                isDotLoading = true
            }
        } //: HSTACK
        .padding(.vertical, 8)
    }
}

struct MorphingAnimationView: View {
    @State private var isStop: Bool = false
    @State private var isPlay: Bool = false
    
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: isStop ? 30 : 5)
                    .frame(width: isStop ? 60 : 250, height: 60)
                    .foregroundStyle(isStop ? Color.blue.gradient : Color.purple.gradient)
                    .overlay {
                        Image(systemName: "mic.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .scaleEffect(isPlay ? 0.7 : 1)
                    }
                
                RoundedRectangle(cornerRadius: isStop ? 35 : 10)
                    .trim(from: 0, to: isStop ? 0.0001 : 1)
                    .stroke(lineWidth: 5)
                    .frame(width: isStop ? 70 : 260, height: 70)
                    .foregroundColor(.purple)
                
            } //: ZSTACK
            .padding()
            .onTapGesture {
                withAnimation(Animation.spring()) {
                    isStop.toggle()
                }
                
                withAnimation(Animation.spring().repeatForever().delay(0.5)) {
                    isPlay.toggle()
                }
            }
            
            Text(isStop ? "Recording..." : "")
                .font(.title2)
                .foregroundColor(.gray)
                .opacity(isPlay ? 0 : 1)
        }
        
    }
}
