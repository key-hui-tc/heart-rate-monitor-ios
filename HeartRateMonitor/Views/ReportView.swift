//
//  ReportView.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 10/30/21.
//

import SwiftUI

struct ReportView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var apiManager: ApiManager

    var body: some View {
        VStack {
            Text("Report")
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
