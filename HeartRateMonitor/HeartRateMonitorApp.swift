//
//  HeartRateMonitorApp.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 10/26/21.
//

import SwiftUI

@main
struct HeartRateMonitorApp: App {
    @Environment(\.scenePhase) var scenePhase

    @ObservedObject private var userManager = UserManager()
    @ObservedObject private var apiManager = ApiManager()

    init() {
        Logger.d("init")
    }

    var body: some Scene {
        WindowGroup {
            if userManager.isLogged {
                HomeView()
                    .environmentObject(userManager)
                    .environmentObject(apiManager)
//                    .animation(.easeOut(duration: 0.5))
//                    .transition(.move(edge: .trailing))
            } else {
                LoginView()
                    .environmentObject(userManager)
                    .environmentObject(apiManager)
            }
        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                Logger.d("active")
            case .background:
                Logger.d("background")
            case .inactive:
                Logger.d("inactive")
            @unknown default:
                Logger.d("unknown")
            }
        }
    }

}
