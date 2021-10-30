//
//  HomeView.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 28/10/2021.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var apiManager: ApiManager

    var body: some View {
        TabView {
            ProfileView()
                .environmentObject(userManager)
                .environmentObject(apiManager)
                .tabItem {
                Label("Profile", systemImage: "list.dash")
            }
            HeartRateView()
                .environmentObject(userManager)
                .environmentObject(apiManager)
                .tabItem {
                Label("Heart Rate", systemImage: "heart.fill")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
