//
//  AlphaSlider.swift
//  ColorTools
//
//  Created by allen on 2025/6/10.
//

import SwiftUI

struct AlphaSlider: View {
    @ObservedObject var colorModel: ColorModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("透明度")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                Spacer()
                Text("\(Int(colorModel.opacity * 100))%")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(minWidth: 40, alignment: .trailing)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Checkerboard background to show transparency
                    CheckerboardBackground()
                        .frame(height: 12)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    
                    // Alpha gradient overlay
                    RoundedRectangle(cornerRadius: 6)
                        .frame(height: 12)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: colorModel.red/255.0, green: colorModel.green/255.0, blue: colorModel.blue/255.0, opacity: 0),
                                    Color(red: colorModel.red/255.0, green: colorModel.green/255.0, blue: colorModel.blue/255.0, opacity: 1)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    // Custom thumb
                    Circle()
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .offset(x: thumbOffset(containerWidth: geometry.size.width))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    updateOpacity(from: gesture.location.x, containerWidth: geometry.size.width)
                                }
                        )
                }
                .contentShape(Rectangle())
                .onTapGesture { location in
                    updateOpacity(from: location.x, containerWidth: geometry.size.width)
                }
            }
            .frame(height: 20)
        }
        .padding(.horizontal)
    }
    
    private func thumbOffset(containerWidth: CGFloat) -> CGFloat {
        let trackWidth = containerWidth
        let progress = colorModel.opacity
        return CGFloat(progress) * (trackWidth - 20)
    }
    
    private func updateOpacity(from xPosition: CGFloat, containerWidth: CGFloat) {
        let trackWidth = containerWidth
        let progress = max(0, min(1, xPosition / trackWidth))
        colorModel.opacity = progress
        colorModel.updateFromOpacity()
    }
}

// Checkerboard background to visualize transparency
struct CheckerboardBackground: View {
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<20, id: \.self) { index in
                Rectangle()
                    .fill(index % 2 == 0 ? Color.white : Color.gray.opacity(0.3))
            }
        }
    }
} 