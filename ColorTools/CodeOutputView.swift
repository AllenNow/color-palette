//
//  CodeOutputView.swift
//  ColorTools
//
//  Created by allen on 2025/6/10.
//

import SwiftUI
import AppKit

struct CodeOutputView: View {
    @ObservedObject var colorModel: ColorModel
    @State private var copiedText: String = ""
    @State private var showCopiedMessage = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("代码输出")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
                .padding(.top)
            
            VStack(spacing: 16) {
                // Swift Color Literal
                CodeBlock(
                    title: "Swift 颜色字面量",
                    code: colorModel.swiftColorLiteral,
                    onCopy: { copyToClipboard(colorModel.swiftColorLiteral) }
                )
                
                // UIColor Hex
                CodeBlock(
                    title: "UIColor (十六进制)",
                    code: colorModel.uiColorHex,
                    onCopy: { copyToClipboard(colorModel.uiColorHex) }
                )
                
                // UIColor RGB
                CodeBlock(
                    title: "UIColor (RGB)",
                    code: colorModel.uiColorRGB,
                    onCopy: { copyToClipboard(colorModel.uiColorRGB) }
                )
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .overlay(
            // Copy confirmation message
            VStack {
                if showCopiedMessage {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("已复制到剪贴板")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(nsColor: .controlBackgroundColor))
                            .shadow(radius: 4)
                    )
                    .transition(.opacity.combined(with: .scale))
                }
                Spacer()
            }
            .animation(.easeInOut(duration: 0.3), value: showCopiedMessage)
        )
    }
    
    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        
        copiedText = text
        showCopiedMessage = true
        
        // Hide message after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showCopiedMessage = false
        }
    }
}

struct CodeBlock: View {
    let title: String
    let code: String
    let onCopy: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    Text(code)
                        .font(.system(size: 14).monospaced())
                        .foregroundColor(.secondary)
                        .padding(.vertical, 8)
                        .textSelection(.enabled)
                }
                
                Button(action: onCopy) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.blue)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(nsColor: .textBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
} 