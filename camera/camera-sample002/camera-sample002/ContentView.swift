//
//  ContentView.swift
//  camera-sample002
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
            } else {
                Text("カメラへのアクセスが許可されていません。")
            }
        }
    }
}

#Preview {
    ContentView()
}
