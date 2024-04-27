//
//  CameraPreviewView.swift
//  sample-camera-app
//
//  Created by Kosuke Takeda on 2024/04/21.
//

import Foundation
import UIKit
import AVFoundation


class CameraPreviewView: UIView, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var videoOutput: AVCaptureVideoDataOutput!
    
    var tappedPoint: CGPoint?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupSession()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        setupSession()
    }
    
    private func setupSession(){
        do {
            // Create capture session
            captureSession = AVCaptureSession()
            captureSession.sessionPreset = .high
            
            // 入力デバイス
            let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position:. unspecified)
            guard
                let deviceInput = try? AVCaptureDeviceInput(device: camera!),
                captureSession.canAddInput(deviceInput)
            else {return}
            captureSession.addInput(deviceInput)
            
            // Preview layer
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = self.bounds
            previewLayer.videoGravity = .resizeAspectFill
            self.layer.addSublayer(previewLayer)
            
            // Create device output
            videoOutput = AVCaptureVideoDataOutput()
            videoOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String): Int(kCVPixelFormatType_32BGRA)]
            if captureSession.canAddOutput(videoOutput){
                captureSession.addOutput(videoOutput)
            }
            videoOutput.setSampleBufferDelegate(self, queue:DispatchQueue(label: "videoQueue"))
            
            
            // tap
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            self.addGestureRecognizer(tapGesture)
            
            // Session start
            // main スレッドではなく background スレッドで呼び出す必要があるようで、DispatchQueue を今回は使用している
            // captureSession.startRunning()
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
            
        } catch {
            print("Error : \(error.localizedDescription)")
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer){
        let locationInView = gesture.location(in: self)
        tappedPoint = locationInView
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){
        guard let tappedPoint = tappedPoint,
                let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        
        let color = context.extractColor(at: tappedPoint, in: ciImage)
        
        DispatchQueue.main.async{
            print("Extracted Color HEX: \(color.hexString)")
        }
        
        self.tappedPoint = nil
    }
}


extension CIContext {
    func extractColor(at position: CGPoint, in image: CIImage) -> UIColor {
        let x = Int(position.x)
        let y = Int(position.y)
        var pixel = [UInt8](repeating: 0, count: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        context.draw(image.cgImage!, in: CGRect(x: -CGFloat(x), y: -CGFloat(y), width: image.extent.width, height: image.extent.height))

        let red = CGFloat(pixel[0]) / 255.0
        let green = CGFloat(pixel[1]) / 255.0
        let blue = CGFloat(pixel[2]) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

extension UIColor {
    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
    }
}
