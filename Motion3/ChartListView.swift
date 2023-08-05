//
//  ChartListView.swift
//  Motion3
//
//  Created by 滝瀬隆斗 on 2023/08/04.
//

import SwiftUI
import Charts
import CoreMotion

struct ChartListView: View {
//    CoreDataの設定
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default) private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                        if let motion = item.motion as? [CMDeviceMotion]{
                            let entry = makeChartEntry(motion: motion)
                            ChartView(data: entry)
//                            let accelerationX = motion.first?.userAcceleration.x
//                            if let accelerationX = accelerationX
//                            {
//                                Text("first acceleration is \(accelerationX)")
//                            }
                            
                        } else {
                            Text("Can't show chart")
                        }
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
//                    if let motion = item.motion as? [CMDeviceMotion] {
////                        var acceleration = motion.map {$0.userAcceleration.x}
////                        var time = motion.map {$0.timestamp}
//                        NavigationLink {
//                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
////                            Log(acceleration: acceleration, time: time)
//                            ChartView(motion: motion)
//                        } label: {
//                            Text(item.timestamp!, formatter: itemFormatter)
//                        }
//                    }
                    
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
            }
            Text("Select an item")
        
        }
    }
    private func saveItem() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }


    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
           saveItem()
        }
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    private func makeChartEntry(motion: [CMDeviceMotion]) -> [ChartEntry]{
        var chartEntries: [ChartEntry] = []
//        self.data = []
//        if let motion = motion
        if let timeZero = motion.first?.timestamp {
            for deviceMotion in motion {
                let time = Double(deviceMotion.timestamp) - Double(timeZero)
                //            let entry = ChartEntry(
                //                time: time,
                //                value: deviceMotion.userAcceleration.x
                //            )
                let entry:ChartEntry = .init(
                    time: time,
                    value: deviceMotion.userAcceleration.x
                )
                chartEntries.append(entry)
                //            self.data.append(entry)
            }
        }
        return chartEntries
    }
}



struct ChartView: View {
//    @State var value: [Double]
//    @State var time: [Double]
//    @State var motion: [CMDeviceMotion]
    @State var data: [ChartEntry] = []
    var body: some View {
        Chart(data, id: \.id) { dataPoint in
//            ForEach(data) {dataPoint in
                
                LineMark(
//                単に配列を２つ渡すのではなく構造体のプロッタブルを渡す必要がある
                    x: .value("time", dataPoint.time),
                    y: .value("value", dataPoint.value)
                )
//                .foregroundStyle(by: .value("Form", data.from))
                .lineStyle(StrokeStyle(lineWidth: 1))
//                .interpolationMethod(.catmullRom)
//            }
        }
    }
        
    
}

struct ChartEntry: Identifiable {
    var time: Double
    var value: Double
//    var color: Color = .green
    var id: String {
        return String(time) + String(value)
    }
}

struct ChartListView_Previews: PreviewProvider {
    static var previews: some View {
        ChartListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
