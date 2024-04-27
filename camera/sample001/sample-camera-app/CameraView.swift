//
//  CameraView.swift
//  sample-camera-app
//
//  Created by Kosuke Takeda on 2024/04/21.
//

import SwiftUI


struct CameraView: UIViewRepresentable {
    @Binding var colorHex: String
    
    func makeUIView(context: Context) -> CameraPreviewView {
        let cameraPreview = CameraPreviewView()
        return cameraPreview
    }
    
    func updateUIView(_ uiView: CameraPreviewView, context: Context){}
    
    typealias UIViewType = CameraPreviewView
}

