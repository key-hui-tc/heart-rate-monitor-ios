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
    @State private var user: UserModel?

    var body: some View {
        VStack {
            Spacer()
            Text("First name: \(user?.firstName ?? "-")")
                .padding()
            Text("Last name: \(user?.lastName ?? "-")")
                .padding()
            Text("Email: \(user?.email ?? "-")")
                .padding()
            Text("Date of birth: \(user?.dob ?? "-")")
                .padding()
            Spacer(minLength: 44)
            Button("LOGOUT") {
                Logger.d("logout")
                userManager.isLogged = false
            }
            Spacer()
        }
            .onAppear {
            getUser()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

extension ProfileView {
    func getUser() {
        // call api
        Task {
            let response = await apiManager.customer().user()
            guard let response = response else {
                return
            }
            user = UserModel(
                id: response.id,
                firstName: response.firstName,
                lastName: response.lastName,
                email: response.email,
                dob: response.dob
            )
        }
    }
}
