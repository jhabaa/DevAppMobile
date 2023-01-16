//
//  DevAppMobileApp.swift
//  DevAppMobile
//
//  Created by Jean Hubert ABA'A on 13/10/2022.
//

import SwiftUI


@main
struct DevAppMobileApp: App {
    @StateObject private var userData = User_DATA()

    var body: some Scene {
        WindowGroup {
                ContentView()
                .environmentObject(userData)
                .onAppear{
                    //Load user data saved on the phone when app is starting
                    User_DATA.Load { result in
                        switch result {
                                          case .failure(let error):
                                              fatalError(error.localizedDescription)
                                          case .success(let user):
                            userData.user = user
                                          }
                    }
                }
        }
    }
}
