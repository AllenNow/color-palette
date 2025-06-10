//
//  ColorModel.swift
//  ColorTools
//
//  Created by allen on 2025/6/10.
//

import SwiftUI
import Foundation

// MARK: - Color Model
class ColorModel: ObservableObject {
    @Published var red: Double = 155.0
    @Published var green: Double = 81.0
    @Published var blue: Double = 245.0
    @Published var opacity: Double = 1.0
    
    @Published var hue: Double = 0.0
    @Published var saturation: Double = 0.0
    @Published var brightness: Double = 0.0
    
    @Published var hexString: String = "9B51F5"
    @Published var rgbString: String = "155, 81, 245"
    
    init() {
        updateFromRGB()
    }
    
    // MARK: - Color Property
    var currentColor: Color {
        Color(red: red/255.0, green: green/255.0, blue: blue/255.0, opacity: opacity)
    }
    
    // MARK: - Code Generation Properties
    var swiftColorLiteral: String {
        let r = red / 255.0
        let g = green / 255.0
        let b = blue / 255.0
        return "#colorLiteral(red: \(String(format: "%.10f", r)), green: \(String(format: "%.10f", g)), blue: \(String(format: "%.10f", b)), alpha: \(String(format: "%.2f", opacity)))"
    }
    
    var uiColorHex: String {
        let hexValue = (Int(red) << 16) | (Int(green) << 8) | Int(blue)
        return "UIColor(hex: 0x\(String(format: "%06X", hexValue))"
    }
    
    var uiColorRGB: String {
        let r = red / 255.0
        let g = green / 255.0
        let b = blue / 255.0
        return "UIColor(red: \(String(format: "%.3f", r)), green: \(String(format: "%.3f", g)), blue: \(String(format: "%.3f", b)), alpha: \(String(format: "%.2f", opacity)))"
    }
    
    // MARK: - Opacity Updates
    func updateFromOpacity() {
        // No color space conversion needed, just update other representations
        hexString = rgbToHex(r: Int(red), g: Int(green), b: Int(blue))
        rgbString = "\(Int(red)), \(Int(green)), \(Int(blue))"
    }
    
    // MARK: - RGB Updates
    func updateFromRGB() {
        let hsv = rgbToHSV(r: red, g: green, b: blue)
        hue = hsv.h
        saturation = hsv.s
        brightness = hsv.v
        
        hexString = rgbToHex(r: Int(red), g: Int(green), b: Int(blue))
        rgbString = "\(Int(red)), \(Int(green)), \(Int(blue))"
    }
    
    // MARK: - HSV Updates
    func updateFromHSV() {
        let rgb = hsvToRGB(h: hue, s: saturation, v: brightness)
        red = rgb.r
        green = rgb.g
        blue = rgb.b
        
        hexString = rgbToHex(r: Int(red), g: Int(green), b: Int(blue))
        rgbString = "\(Int(red)), \(Int(green)), \(Int(blue))"
    }
    
    // MARK: - Hex Updates
    func updateFromHex(_ hex: String) {
        objectWillChange.send()
        let cleanHex = hex.replacingOccurrences(of: "#", with: "")
        if let rgb = hexToRGB(hex: cleanHex) {
            red = Double(rgb.r)
            green = Double(rgb.g)
            blue = Double(rgb.b)
            
            let hsv = rgbToHSV(r: red, g: green, b: blue)
            hue = hsv.h
            saturation = hsv.s
            brightness = hsv.v
            
            hexString = cleanHex.uppercased()
            rgbString = "\(Int(red)), \(Int(green)), \(Int(blue))"
        }
    }
    
    // MARK: - RGB String Updates
    func updateFromRGBString(_ rgbStr: String) {
        objectWillChange.send()
        let components = rgbStr.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        if components.count == 3,
           let r = Double(components[0]),
           let g = Double(components[1]),
           let b = Double(components[2]),
           r >= 0 && r <= 255 && g >= 0 && g <= 255 && b >= 0 && b <= 255 {
            
            red = r
            green = g
            blue = b
            
            let hsv = rgbToHSV(r: red, g: green, b: blue)
            hue = hsv.h
            saturation = hsv.s
            brightness = hsv.v
            
            hexString = rgbToHex(r: Int(red), g: Int(green), b: Int(blue))
            rgbString = "\(Int(red)), \(Int(green)), \(Int(blue))"
        }
    }
}

// MARK: - Color Conversion Functions
extension ColorModel {
    
    // RGB to HSV
    private func rgbToHSV(r: Double, g: Double, b: Double) -> (h: Double, s: Double, v: Double) {
        let rNorm = r / 255.0
        let gNorm = g / 255.0
        let bNorm = b / 255.0
        
        let maxVal = max(rNorm, gNorm, bNorm)
        let minVal = min(rNorm, gNorm, bNorm)
        let delta = maxVal - minVal
        
        // Hue calculation
        var hue: Double = 0
        if delta != 0 {
            if maxVal == rNorm {
                hue = 60 * (((gNorm - bNorm) / delta).truncatingRemainder(dividingBy: 6))
            } else if maxVal == gNorm {
                hue = 60 * (((bNorm - rNorm) / delta) + 2)
            } else {
                hue = 60 * (((rNorm - gNorm) / delta) + 4)
            }
        }
        if hue < 0 { hue += 360 }
        
        // Saturation calculation
        let saturation = maxVal == 0 ? 0 : delta / maxVal
        
        // Value calculation
        let brightness = maxVal
        
        return (hue, saturation, brightness)
    }
    
    // HSV to RGB
    private func hsvToRGB(h: Double, s: Double, v: Double) -> (r: Double, g: Double, b: Double) {
        let c = v * s
        let x = c * (1 - abs((h / 60).truncatingRemainder(dividingBy: 2) - 1))
        let m = v - c
        
        var rPrime: Double = 0
        var gPrime: Double = 0
        var bPrime: Double = 0
        
        if h >= 0 && h < 60 {
            rPrime = c; gPrime = x; bPrime = 0
        } else if h >= 60 && h < 120 {
            rPrime = x; gPrime = c; bPrime = 0
        } else if h >= 120 && h < 180 {
            rPrime = 0; gPrime = c; bPrime = x
        } else if h >= 180 && h < 240 {
            rPrime = 0; gPrime = x; bPrime = c
        } else if h >= 240 && h < 300 {
            rPrime = x; gPrime = 0; bPrime = c
        } else if h >= 300 && h < 360 {
            rPrime = c; gPrime = 0; bPrime = x
        }
        
        let r = (rPrime + m) * 255
        let g = (gPrime + m) * 255
        let b = (bPrime + m) * 255
        
        return (r, g, b)
    }
    
    // RGB to Hex
    private func rgbToHex(r: Int, g: Int, b: Int) -> String {
        return String(format: "%02X%02X%02X", r, g, b)
    }
    
    // Hex to RGB
    private func hexToRGB(hex: String) -> (r: Int, g: Int, b: Int)? {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        guard hexSanitized.count == 6 else { return nil }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgbValue)
        
        let r = Int((rgbValue & 0xFF0000) >> 16)
        let g = Int((rgbValue & 0x00FF00) >> 8)
        let b = Int(rgbValue & 0x0000FF)
        
        return (r, g, b)
    }
} 