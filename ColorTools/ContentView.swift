//
//  ContentView.swift
//  ColorTools
//
//  Created by allen on 2025/6/10.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var colorModel = ColorModel()
    @State private var selectedTab = 0
    
    var body: some View {
        HSplitView {
            // Left Panel - Color Tools
            NavigationView {
                ScrollView {
                    VStack(spacing: 24) {
                        // Color Preview at the top
                        ColorPreview(colorModel: colorModel)
                        
                        // Tab selection (removed "代码" tab)
                        Picker("Color Tool", selection: $selectedTab) {
                            Text("调色板").tag(0)
                            Text("滑块").tag(1)
                            Text("输入").tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        
                        // Content based on selected tab
                        switch selectedTab {
                        case 0:
                            // Circular Color Picker
                            VStack(spacing: 16) {
                                CircularColorPicker(colorModel: colorModel)
                                
                                // Brightness slider
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("亮度")
                                            .font(.system(size: 16, weight: .medium))
                                        Spacer()
                                        Text("\(Int(colorModel.brightness * 100))%")
                                            .font(.system(size: 16, weight: .medium))
                                            .frame(minWidth: 40, alignment: .trailing)
                                    }
                                    
                                    HStack {
                                        Color.black
                                            .frame(width: 20, height: 20)
                                            .clipShape(Circle())
                                        
                                        Slider(value: $colorModel.brightness, in: 0...1) { _ in
                                            colorModel.updateFromHSV()
                                        }
                                        
                                        Color.white
                                            .frame(width: 20, height: 20)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                        case 1:
                            // RGB Sliders
                            RGBSliders(colorModel: colorModel)
                            
                        case 2:
                            // Input Fields
                            ColorInputFields(colorModel: colorModel)
                            
                        default:
                            EmptyView()
                        }
                        
                        // Alpha slider (appears in all tabs)
                        VStack(spacing: 16) {
                            Divider()
                                .padding(.horizontal)
                            
                            AlphaSlider(colorModel: colorModel)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.vertical)
                }
                .navigationTitle("颜色工具")
                .background(Color(nsColor: .controlBackgroundColor))
            }
            .frame(minWidth: 400, idealWidth: 500)
            
            // Right Panel - Code Output (Fixed)
            NavigationView {
                CodeOutputView(colorModel: colorModel)
                    .navigationTitle("代码输出")
                    .background(Color(nsColor: .controlBackgroundColor))
            }
            .frame(minWidth: 400)
        }
    }
}

#Preview {
    ContentView()
}
