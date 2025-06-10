//
//  ColorInputFields.swift
//  ColorTools
//
//  Created by allen on 2025/6/10.
//

import SwiftUI

struct ColorInputFields: View {
    @ObservedObject var colorModel: ColorModel
    @State private var tempHexString: String = ""
    @State private var tempRGBString: String = ""
    @State private var isEditingHex = false
    @State private var isEditingRGB = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Hex Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Hex Color #")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                HStack {
                    Text("#")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    TextField("9B51F5", text: isEditingHex ? $tempHexString : $colorModel.hexString)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.system(size: 16).monospaced())
                        .disableAutocorrection(true)
                        .onTapGesture {
                            if !isEditingHex {
                                tempHexString = colorModel.hexString
                                isEditingHex = true
                            }
                        }
                        .onSubmit {
                            submitHexValue()
                        }
                        .onChange(of: tempHexString) { newValue in
                            // Validate hex input as user types
                            let filtered = newValue.filter { "0123456789ABCDEFabcdef".contains($0) }
                            if filtered != newValue {
                                tempHexString = String(filtered.prefix(6))
                            } else if filtered.count > 6 {
                                tempHexString = String(filtered.prefix(6))
                            }
                        }
                }
            }
            
            // RGB Input
            VStack(alignment: .leading, spacing: 8) {
                Text("RGB Color")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                TextField("155, 81, 245", text: isEditingRGB ? $tempRGBString : $colorModel.rgbString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16).monospaced())
                    .disableAutocorrection(true)
                    .onTapGesture {
                        if !isEditingRGB {
                            tempRGBString = colorModel.rgbString
                            isEditingRGB = true
                        }
                    }
                    .onSubmit {
                        submitRGBValue()
                    }
            }
        }
        .padding(.horizontal)
        // Handle taps outside to commit changes
        .onTapGesture {
            if isEditingHex {
                submitHexValue()
            }
            if isEditingRGB {
                submitRGBValue()
            }
        }
    }
    
    private func submitHexValue() {
        let cleanHex = tempHexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanHex.count == 6 && cleanHex.allSatisfy({ "0123456789ABCDEFabcdef".contains($0) }) {
            colorModel.updateFromHex(cleanHex)
        }
        isEditingHex = false
        tempHexString = ""
    }
    
    private func submitRGBValue() {
        let cleanRGB = tempRGBString.trimmingCharacters(in: .whitespacesAndNewlines)
        if isValidRGBString(cleanRGB) {
            colorModel.updateFromRGBString(cleanRGB)
        }
        isEditingRGB = false
        tempRGBString = ""
    }
    
    private func isValidRGBString(_ rgbString: String) -> Bool {
        let components = rgbString.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        guard components.count == 3 else { return false }
        
        for component in components {
            guard let value = Int(component), value >= 0 && value <= 255 else {
                return false
            }
        }
        return true
    }
} 