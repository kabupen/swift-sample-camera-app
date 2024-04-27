//
//  ContentView.swift
//  camera-sample003
//
//  Created by Kosuke Takeda on 2024/04/27.
//

import SwiftUI

struct ContentView: View {
    @StateObject var cameraViewModel = CameraViewModel()
    
    var body: some View {
        VStack {
            if cameraViewModel.isCameraAuthorized {
                CameraView()
                    .environmentObject(cameraViewModel)
                    .onAppear {
                        cameraViewModel.startSession()
                    }
                    .onDisappear {
                        cameraViewModel.stopSession()
                    }
                
                Text("Sucess...")
                
            } else {
                Text("カメラへのアクセス許可がされていません。")
            }
        }
    }
}
