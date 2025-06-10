//
//  CircularColorPicker.swift
//  ColorTools
//
//  Created by allen on 2025/6/10.
//

import SwiftUI

struct CircularColorPicker: View {
    @ObservedObject var colorModel: ColorModel
    @State private var isDragging = false
    
    private let size: CGFloat = 250
    private let innerRadius: CGFloat = 20
    
    var body: some View {
        ZStack {
            // Smooth HSV Color Wheel using gradients
            ZStack {
                // Angular gradient for hue distribution
                AngularGradient(
                    gradient: Gradient(colors: [
                        .red,    // 0°
                        .yellow, // 60°
                        .green,  // 120°
                        .cyan,   // 180°
                        .blue,   // 240°
                        Color(red: 1, green: 0, blue: 1),// 300° - magenta
                        .red     // 360° (back to start)
                    ]),
                    center: .center
                )
                
                // Radial gradient for saturation (white center to transparent edge)
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color.white.opacity(0.8),
                        Color.white.opacity(0.3),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: innerRadius,
                    endRadius: size / 2
                )
                .blendMode(.overlay)
                
                // Brightness overlay based on current brightness value
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(1 - colorModel.brightness),
                        Color.black.opacity((1 - colorModel.brightness) * 0.7),
                        Color.black.opacity((1 - colorModel.brightness) * 0.3),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: innerRadius,
                    endRadius: size / 2
                )
                .blendMode(.multiply)
            }
            .frame(width: size, height: size)
            .clipShape(Circle())
            
            // Inner circle mask to create the hole in the center
            Circle()
                .fill(Color(nsColor: .controlBackgroundColor))
                .frame(width: innerRadius * 2, height: innerRadius * 2)
            
            // Brightness indicator in center
            Circle()
                .fill(Color(hue: colorModel.hue / 360.0, 
                           saturation: colorModel.saturation, 
                           brightness: colorModel.brightness))
                .frame(width: innerRadius * 1.6, height: innerRadius * 1.6)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            
            // Selection indicator
            Circle()
                .strokeBorder(Color.white, lineWidth: 3)
                .background(Circle().fill(colorModel.currentColor))
                .frame(width: 20, height: 20)
                .position(indicatorPosition)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 1)
                .overlay(
                    Circle()
                        .strokeBorder(Color.black.opacity(0.2), lineWidth: 1)
                        .frame(width: 20, height: 20)
                        .position(indicatorPosition)
                )
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    isDragging = true
                    updateColor(at: value.location)
                }
                .onEnded { _ in
                    isDragging = false
                }
        )
    }
    
    private var indicatorPosition: CGPoint {
        let center = CGPoint(x: size / 2, y: size / 2)
        let radius = (size / 2 - innerRadius) * colorModel.saturation + innerRadius
        let angle = colorModel.hue * .pi / 180
        
        let x = center.x + cos(angle) * radius
        let y = center.y + sin(angle) * radius
        
        return CGPoint(x: x, y: y)
    }
    
    private func updateColor(at location: CGPoint) {
        let center = CGPoint(x: size / 2, y: size / 2)
        let dx = location.x - center.x
        let dy = location.y - center.y
        let distance = sqrt(dx * dx + dy * dy)
        
        // Check if touch is within the valid area
        guard distance >= innerRadius && distance <= size / 2 else { return }
        
        // Calculate angle (hue)
        var angle = atan2(dy, dx) * 180 / .pi
        if angle < 0 { angle += 360 }
        
        // Calculate saturation
        let maxRadius = size / 2 - innerRadius
        let saturation = min(max((distance - innerRadius) / maxRadius, 0), 1)
        
        // Update color model
        colorModel.hue = angle
        colorModel.saturation = saturation
        colorModel.updateFromHSV()
    }
} 