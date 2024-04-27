//
//  CameraView.swift
//  camera-sample002
//
//  Created by Kosuke Takeda on 2024/04/27.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
    @EnvironmentObject var cameraViewModel: CameraViewModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        cameraViewModel.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: cameraViewModel.session)
        cameraViewModel.videoPreviewLayer?.videoGravity = .resizeAspectFill
        cameraViewModel.videoPreviewLayer?.frame = view.frame
        view.layer.addSublayer(cameraViewModel.videoPreviewLayer!)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
