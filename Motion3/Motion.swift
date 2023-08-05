//
//  Motion.swift
//  Motion3
//
//  Created by 滝瀬隆斗 on 2023/08/04.
//

import CoreMotion




class MotionSensor: ObservableObject {
//    マネージャ設定
    private var motionManager = CMMotionManager()
//    表示データ設定
    @Published var nxString = "0.0"
    @Published var nyString = "0.0"
    @Published var nzString = "0.0"
    @Published var motionData: [CMDeviceMotion] = []
//    @Published var nmotion = CMDeviceMotion()
//    状態設定
    var isStarted = false
    
//    スタート関数
    func start() {
        isStarted = true
//        motionManager = CMMotionManager()
        motionData = []
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(motion:CMDeviceMotion?, error:Error?) in
                if let error = error {
                            // エラーメッセージを表示して、適切な対処を行う
                            print("Device Motion Error: \(error)")
                        } else {
                            if let motion = motion {
                                self.updateMotionData(deviceMotion: motion)
                            }
                        }
            })
        }
        
    }
//    ストップ関数
    func stop() {
        isStarted = false
        motionManager.stopDeviceMotionUpdates()
    }
    
    func updateMotionData(deviceMotion: CMDeviceMotion) {
        nxString = String(deviceMotion.userAcceleration.x)
        nyString = String(deviceMotion.userAcceleration.y)
        nzString = String(deviceMotion.userAcceleration.z)
//        motionData.time.append(deviceMotion.timestamp)
//        motionData.userAcceleration.append(deviceMotion.userAcceleration)
//        motionData.rotationRate.append(deviceMotion.rotationRate)
        motionData.append(deviceMotion)
//        print(motionData)
    }
}
