//
//  RGBSliders.swift
//  ColorTools
//
//  Created by allen on 2025/6/10.
//

import SwiftUI

struct RGBSliders: View {
    @ObservedObject var colorModel: ColorModel
    
    var body: some View {
        VStack(spacing: 15) {
            // Red Slider
            ColorSlider(
                title: "Red",
                value: $colorModel.red,
                range: 0...255,
                trackColors: [
                    Color(red: 0, green: colorModel.green/255.0, blue: colorModel.blue/255.0),
                    Color(red: 1, green: colorModel.green/255.0, blue: colorModel.blue/255.0)
                ],
                onValueChanged: {
                    colorModel.updateFromRGB()
                }
            )
            
            // Green Slider
            ColorSlider(
                title: "Green",
                value: $colorModel.green,
                range: 0...255,
                trackColors: [
                    Color(red: colorModel.red/255.0, green: 0, blue: colorModel.blue/255.0),
                    Color(red: colorModel.red/255.0, green: 1, blue: colorModel.blue/255.0)
                ],
                onValueChanged: {
                    colorModel.updateFromRGB()
                }
            )
            
            // Blue Slider
            ColorSlider(
                title: "Blue",
                value: $colorModel.blue,
                range: 0...255,
                trackColors: [
                    Color(red: colorModel.red/255.0, green: colorModel.green/255.0, blue: 0),
                    Color(red: colorModel.red/255.0, green: colorModel.green/255.0, blue: 1)
                ],
                onValueChanged: {
                    colorModel.updateFromRGB()
                }
            )
        }
        .padding(.horizontal)
    }
}

struct ColorSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let trackColors: [Color]
    let onValueChanged: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                Spacer()
                Text("\(Int(value))")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(minWidth: 35, alignment: .trailing)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Track background with gradient
                    LinearGradient(
                        gradient: Gradient(colors: trackColors),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .frame(height: 12)
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
                                    updateValue(from: gesture.location.x, containerWidth: geometry.size.width)
                                }
                        )
                }
                .contentShape(Rectangle())
                .onTapGesture { location in
                    updateValue(from: location.x, containerWidth: geometry.size.width)
                }
            }
            .frame(height: 20)
        }
    }
    
    private func thumbOffset(containerWidth: CGFloat) -> CGFloat {
        let trackWidth = containerWidth
        let progress = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return CGFloat(progress) * (trackWidth - 20)
    }
    
    private func updateValue(from xPosition: CGFloat, containerWidth: CGFloat) {
        let trackWidth = containerWidth
        let progress = max(0, min(1, xPosition / trackWidth))
        let newValue = range.lowerBound + progress * (range.upperBound - range.lowerBound)
        value = newValue
        onValueChanged()
    }
} 