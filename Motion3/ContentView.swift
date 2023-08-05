//
//  ContentView.swift
//  Motion3
//
//  Created by 滝瀬隆斗 on 2023/08/03.
//

import SwiftUI
//import Charts
//import CoreMotion

struct ContentView: View {
    var body: some View {
        TabView {
            MesureView()
                .tabItem(){
                    Image(systemName: "1.circle.fill")
                }
            ChartListView()
                .tabItem(){
                    Image(systemName: "2.circle.fill")
                }
            
        }
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
