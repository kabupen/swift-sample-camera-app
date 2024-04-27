//
//  CameraViewModel.swift
//  camera-sample002
//
//  Created by Kosuke Takeda on 2024/04/27.
//

import AVFoundation
import SwiftUI

class CameraViewModel: NSObject, ObservableObject {
    @Published var isCameraAuthorized = false
    let session = AVCaptureSession()
    var output = AVCapturePhotoOutput()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    override init() {
        super.init()
        checkCameraAuthorization()
        setupSession()
    }

    private func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isCameraAuthorized = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                DispatchQueue.main.async {
                    self.isCameraAuthorized = authorized
                    if authorized {
                        self.setupSession()
                    }
                }
            }
        default:
            isCameraAuthorized = false
        }
    }

    private func setupSession() {
        guard isCameraAuthorized, let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            session.startRunning()
        } catch {
            print(error)
        }
    }

    func startSession() {
        if !session.isRunning {
            session.startRunning()
        }
    }

    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
    }

    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let _ = UIImage(data: imageData) else {
            return
        }
        // Save or process the image
    }
}
