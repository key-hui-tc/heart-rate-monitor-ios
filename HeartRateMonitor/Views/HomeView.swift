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
            ReportView()
                .environmentObject(userManager)
                .environmentObject(apiManager)
                .tabItem {
                Label("Report", systemImage: "list.bullet.rectangle")
            }
            HeartRateView()
                .environmentObject(userManager)
                .environmentObject(apiManager)
                .tabItem {
                Label("Heart Rate", systemImage: "heart.fill")
            }
            ProfileView()
                .environmentObject(userManager)
                .environmentObject(apiManager)
                .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
