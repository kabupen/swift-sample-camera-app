//
//  CameraViewModel.swift
//  camera-sample003
//
//  Created by Kosuke Takeda on 2024/04/27.
//

import AVFoundation
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var isCameraAuthorized = false
    @Published var processedImage = UIImage()
    let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    @Published var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private let context = CIContext()
    private let edgeDetectionFilter = CIFilter.edgeWork()

    override init() {
        super.init()
        checkCameraAuthorization()
        setupSession()
    }
    
    private func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for:  .video){
        case .authorized:
            isCameraAuthorized = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){
                authorized in DispatchQueue.main.async {
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
            // input
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            // output
            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)
                videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            }
            session.startRunning()
        } catch {
            print(error)
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // カメラのピクセルバッファを取得、生画像データ
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        // get Core Image object
        let ciImage = CIImage(cvImageBuffer: pixelBuffer)
        
        // filtering
        edgeDetectionFilter.inputImage = ciImage
        edgeDetectionFilter.radius = 1.0
        
        // 画像の更新
        if let outputImage = edgeDetectionFilter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            DispatchQueue.main.async {
                self.processedImage = UIImage(cgImage: cgImage)
            }
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
}
