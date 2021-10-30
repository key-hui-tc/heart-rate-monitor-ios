//
//  UserModel.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

import Foundation

struct UserModel: BaseModel {
    let id: Int64
    let firstName: String
    let lastName: String
    let email: String
    let dob: String
}
