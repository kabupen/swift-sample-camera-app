//
//  CameraView.swift
//  camera-sample003
//
//  Created by Kosuke Takeda on 2024/04/27.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
    @EnvironmentObject var cameraViewModel: CameraViewModel
   
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black
        
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.image = cameraViewModel.processedImage
        // imageView.isUserInteractionEnabled = false
        view.addSubview(imageView)
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        
        if let imageView = uiView.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
            if let cgImage = cameraViewModel.processedImage.cgImage {
                let imageOrientation = UIImage.Orientation.right  // 90度右に回転
                let orientedImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: imageOrientation)
                imageView.image = orientedImage
            }
        }
    }
}
