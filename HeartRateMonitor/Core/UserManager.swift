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

    let storedUsername = "Tester"
    let storedPassword = "pass"
}
