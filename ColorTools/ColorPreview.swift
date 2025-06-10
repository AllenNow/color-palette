//
//  ColorPreview.swift
//  ColorTools
//
//  Created by allen on 2025/6/10.
//

import SwiftUI

struct ColorPreview: View {
    @ObservedObject var colorModel: ColorModel
    
    var body: some View {
        VStack(spacing: 12) {
            // Color preview square with transparency support
            ZStack {
                // Checkerboard background for transparency visualization
                CheckerboardPattern()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Color overlay
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorModel.currentColor)
                    .frame(width: 120, height: 120)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            // Color info
            VStack(spacing: 4) {
                Text("当前颜色")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text("#\(colorModel.hexString)")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(.primary)
                
                Text("RGB(\(Int(colorModel.red)), \(Int(colorModel.green)), \(Int(colorModel.blue)))")
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.secondary)
                
                Text("透明度: \(Int(colorModel.opacity * 100))%")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(nsColor: .controlBackgroundColor))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

// Checkerboard pattern for transparency visualization
struct CheckerboardPattern: View {
    let squareSize: CGFloat = 8
    
    var body: some View {
        GeometryReader { geometry in
            let cols = Int(geometry.size.width / squareSize) + 1
            let rows = Int(geometry.size.height / squareSize) + 1
            
            VStack(spacing: 0) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<cols, id: \.self) { col in
                            Rectangle()
                                .fill((row + col) % 2 == 0 ? Color.white : Color.gray.opacity(0.3))
                                .frame(width: squareSize, height: squareSize)
                        }
                    }
                }
            }
        }
    }
} 
