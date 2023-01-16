//
//  Notiifcation.swift
//  DevAppMobile
//
//  Created by Jean Hubert ABA'A on 01/11/2022.
//

import SwiftUI

struct Notiifcation: View {
    @State private var showVStack = false
    @State var textToShow : String
        var body: some View {
            GeometryReader { GeometryProxy in
                VStack {
                    if showVStack {
                        VStack {
                            HStack{
                                Text("Notification")
                                    .bold()
                                    .font(.title)
                                    .monospacedDigit()
                                    .padding(5)
                            }
                            .background {
                                Rectangle().fill(.thinMaterial)
                                    .cornerRadius(20)
                                    .shadow(color: .green, radius: 10, x: 2, y: 2)
                            }
                            
                            
                        }
                        .transition(.opacity)
                        .animation(Animation.easeInOut(duration: 5).delay(0))
                        .onAppear{
                            Task{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                    showVStack.toggle()
                                }
                            }
                        }
                    }
                }
                .frame(width: GeometryProxy.size.width, height: .infinity, alignment: Alignment.center)
            }
            .onAppear{
                showVStack = true
            }
            .background(.ultraThinMaterial)
        }
    
    
}

struct Notification_Previews: PreviewProvider {
    static var previews: some View {
        Notiifcation(textToShow: "Notification")
        //NavBar()
        //CardsView()
    }
}

