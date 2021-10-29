//
//  ContentView.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 10/26/21.
//

import SwiftUI

let lightGreyColor = Color(
    red: 239.0 / 255.0,
    green: 243.0 / 255.0,
    blue: 244.0 / 255.0,
    opacity: 1.0
)

struct LoginView: View {

    @EnvironmentObject var userManager: UserManager

    @State var username = ""
    @State var password = ""
    @State var authenticationDidFail = false
    @State var authenticationDidSucceed = false

    func onTapLogin() {
        userManager.isLogged = true
        // TODO: validation
//        if self.username == userManager.storedUsername &&
//            self.password == userManager.storedPassword {
//            self.authenticationDidSucceed = true
//            self.authenticationDidFail = false
//            userManager.isLogged = true
//        } else {
//            self.authenticationDidFail = true
//            userManager.isLogged = false
//        }
    }

    var body: some View {
        ZStack {
            VStack {
                TitleText()
                UsernameTextField(username: $username)
                PasswordSecureField(password: $password)
                if authenticationDidFail {
                    Text("Information not correct. Try again.")
                        .offset(y: -10)
                        .foregroundColor(.red)
                }
                Button(action: onTapLogin) {
                    LoginButtonText()
                }
            }
                .padding()

            if authenticationDidSucceed {
                Text("Login succeeded!")
                    .font(.headline)
                    .frame(width: 250, height: 80)
                    .background(Color.green)
                    .cornerRadius(20.0)
                    .foregroundColor(.white)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct TitleText: View {
    var body: some View {
        Text("Heart Rate Monitor")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct LoginButtonText: View {
    var body: some View {
        Text("LOGIN")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(.red)
            .cornerRadius(15.0)
    }
}

struct UsernameTextField: View {

    @Binding var username: String

    var body: some View {
        TextField("Username", text: $username)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}

struct PasswordSecureField: View {

    @Binding var password: String

    var body: some View {
        SecureField("Password", text: $password)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}
