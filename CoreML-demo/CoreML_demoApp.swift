//
//  CoreML_demoApp.swift
//  CoreML-demo
//
//  Created by Martin Regas on 15/09/2023.
//

import SwiftUI

@main
struct CoreML_demoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(GameHelper())
        }
    }
}
