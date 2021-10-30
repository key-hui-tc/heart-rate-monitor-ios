//
//  ProfileView.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 28/10/2021.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var apiManager: ApiManager

    var body: some View {
        VStack {
            Spacer()
            Text("First name: \(userManager.user?.firstName ?? "-")")
            Text("Last name: \(userManager.user?.lastName ?? "-")")
            Text("Email: \(userManager.user?.email ?? "-")")
            Text("Date of birth: \(userManager.user?.dob ?? "-")")
            Spacer(minLength: 44)
            Button("LOGOUT") {
                Logger.d("logout")
                userManager.isLogged = false
            }
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
