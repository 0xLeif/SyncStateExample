//
//  SyncStateExampleApp.swift
//  SyncStateExample
//
//  Created by Leif on 3/1/24.
//

import AppState
import SwiftUI

@main
struct SyncStateExampleApp: App {
    init() {
        Application
            .promote(to: CustomApplication.self)
            .logging(isEnabled: true)
            .load(dependency: \.icloudStore)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
