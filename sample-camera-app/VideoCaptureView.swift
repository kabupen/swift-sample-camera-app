//
//  VideoCaptureView.swift
//  sample-camera-app
//
//  Created by Kosuke Takeda on 2024/04/27.
//

import SwiftUI
import UIKit

struct VideoCaptureView: UIViewControllerRepresentable {
    
    @Binding var isSown: Bool
    @Binding var videoURL: URL?
    
    func makeUIViewController(context: Context) -> some UIImagePickerController{
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.mediaTypes = ["public.movie"]
        picker.cameraCaptureMode = .video
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
        
    func makeCoordinator() -> () {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: VideoCaptureView
        
        init(_ videoCaptureView: VideoCaptureView){
            self.parent = videoCaptureView
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
            if let url = info[.mediaURL] as? URL {
                parent.videoURL = url
            }
            parent.isShown = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShown = false
        }
    }
}
