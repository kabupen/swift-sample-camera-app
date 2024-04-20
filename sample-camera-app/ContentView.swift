//
//  ContentView.swift
//  sample-camera-app
//
//  Created by Kosuke Takeda on 2024/04/20.
//

import SwiftUI

struct ContentView: View {
    @State private var colorHex: String = "#FFFFFF"

    var body: some View {
        VStack {
            CameraView(colorHex: $colorHex)
                .frame(height: 400)
            Text("Color: \(colorHex)")
                .font(.title)
                .padding()
        }
    }
}
