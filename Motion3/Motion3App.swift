//
//  Motion3App.swift
//  Motion3
//
//  Created by 滝瀬隆斗 on 2023/08/03.
//

//import SwiftUI
//
//@main
//struct Motion3App: App {
//    let persistenceController = PersistenceController.shared
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        }
//    }
//}
import SwiftUI
import CoreData
import CoreMotion

@main
struct Motion3App: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        // 変換クラスの登録
        ValueTransformer.setValueTransformer(CMDeviceMotionArrayTransformer(), forName: NSValueTransformerName(rawValue: "CMDeviceMotionArrayTransformer"))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

class CMDeviceMotionArrayTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override func transformedValue(_ value: Any?) -> Any? {
        if let motions = value as? [CMDeviceMotion] {
            return try? NSKeyedArchiver.archivedData(withRootObject: motions, requiringSecureCoding: true)
        }
        return nil
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        if let data = value as? Data {
            return try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, CMDeviceMotion.self], from: data)
        }
        return nil
    }
}

