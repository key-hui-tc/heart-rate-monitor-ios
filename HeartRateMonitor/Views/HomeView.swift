//
//  HomeView.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 28/10/2021.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var userManager: UserManager

    var body: some View {
        TabView {
            HeartRateView()
                .tabItem {
                Label("Heart Rate", systemImage: "heart.fill")
            }
            ProfileView()
                .tabItem {
                Label("Profile", systemImage: "list.dash")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
