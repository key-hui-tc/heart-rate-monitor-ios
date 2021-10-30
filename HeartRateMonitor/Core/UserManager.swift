//
//  UserManager.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

import SwiftUI

class UserManager: ObservableObject {
    @Published var isLogged = false
    @Published var user: UserModel?

    var token: String? = nil

    // debug locally
    static let debugUsername = "Tester"
    static let debugPassword = "pass"

    func login(token: String) {
        self.token = token
        self.isLogged = true
    }

    func logout() {
        token = nil
        self.isLogged = false
    }
}
