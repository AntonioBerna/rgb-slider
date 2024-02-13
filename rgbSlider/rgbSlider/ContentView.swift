//
//  ContentView.swift
//  rgbSlider
//
//  Created by Antonio Bernardini on 13/02/24.
//

import SwiftUI

struct ContentView: View {
    @State private var redValue: Double = 127
    @State private var greenValue: Double = 127
    @State private var blueValue: Double = 127
    
    @State private var hexOutputColor: Color = .white
    
    var body: some View {
        VStack {
            ZStack {
                Color(hex: calculateHex())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Text("\(calculateHex())")
                    .fontWeight(.bold)
                    .foregroundColor(hexOutputColor)
                    .font(.system(size: 50, design: .rounded))
            }
            
            ColorSlider(value: $redValue, label: "R")
            ColorSlider(value: $greenValue, label: "G")
            ColorSlider(value: $blueValue, label: "B")
        }
        .onChange(of: [redValue, greenValue, blueValue]) { _ in
            updateForegroundColor()
        }
    }
    
    private func calculateHex() -> String {
        String(format: "#%02X%02X%02X", Int(redValue), Int(greenValue), Int(blueValue))
    }
    
    private func updateForegroundColor() {
        hexOutputColor = (redValue + greenValue + blueValue) > 382 ? .black : .white
    }
}

struct ColorSlider: View {
    @Binding var value: Double
    let label: String
    
    var body: some View {
        HStack {
            Text(label)
            Slider(value: $value, in: 0...255, step: 1)
                .accentColor(.white)
            TextField("\(label) Value", value: $value, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 50)
        }
        .padding()
    }
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
