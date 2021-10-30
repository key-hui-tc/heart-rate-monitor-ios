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

    func login(token: String) {
        self.token = token
        self.isLogged = true
    }

    func logout() {
        token = nil
        self.isLogged = false
    }

    func getId() -> Int64? {
        if AppGlobal.mock {
            return 0
        }
        return user?.id
    }
}
