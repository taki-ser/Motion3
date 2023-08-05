//
//  MesureView.swift
//  Motion3
//
//  Created by 滝瀬隆斗 on 2023/08/04.
//

import SwiftUI

struct MesureView: View {
//    CoreDataの設定
    @Environment(\.managedObjectContext) private var viewContext
//    ステータス設定
    @State var isStarted = false
//    センサ設定
    @ObservedObject var motionSensor = MotionSensor()

    var body: some View {
        VStack {
            Text(String(motionSensor.nxString))
            Text(String(motionSensor.nyString))
            Text(String(motionSensor.nzString))
            Button(action: {
                isStarted.toggle()
                if isStarted {
                    self.motionSensor.start()
                    let _ = print("start")
                    
                }
                else {
                    self.motionSensor.stop()
                    addItem()
//                    saveItem()
                    let _ = print("stop")
                    
                }
                
//                isStarted ? self.motionSensor.stop() : self.motionSensor.start()
                
            }) {
                isStarted ? Text("STOP") : Text("START")
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.motion = motionSensor.motionData as NSObject
//            print(newItem)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
    //            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                print("Error saving item: \(nsError), \(nsError.userInfo)")
            }
        }
    }
//    private func saveItem() {
//
//    }
}

struct MesureView_Previews: PreviewProvider {
    static var previews: some View {
        MesureView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
