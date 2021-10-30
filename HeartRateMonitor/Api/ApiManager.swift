//
//  ApiManager.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

// REST API
// https://raw.githubusercontent.com/Prenetics/test-api/master/api.json
// https://editor.swagger.io

import SwiftUI

class ApiManager: ObservableObject {
    func customer() -> CustomerService {
        return CustomerService()
    }

    func genetics() -> GeneticsService {
        return GeneticsService()
    }

    func lifestyle() -> LifestyleService {
        return LifestyleService()
    }
}
