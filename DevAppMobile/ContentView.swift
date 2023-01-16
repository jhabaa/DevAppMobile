//
//  ContentView.swift
//  DevAppMobile
//
//  Created by Jean Hubert ABA'A on 13/10/2022.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var current_user:User_DATA
    @Environment(\.scenePhase) private var scenePhase // Pour l'enregistrement automatique
    @State private var user_data = User_DATA()
    
    var body: some View {
        GeometryReader {
           
            GeometryProxy in
            if (current_user.user.authentificated == true){
                Menu().transition(.identity)
            }else{
                Notiifcation(textToShow: "Welcome")
                LoginScreen().transition(.identity)
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
