//
//  HowToUse.swift
//  DevAppMobile
//
//  Created by Jean Hubert ABA'A on 20/10/2022.
//

import SwiftUI
import SceneKit

extension Animation{
    static func loading() -> Animation{
        Animation.spring().repeatForever()
        
    }
}

struct HowToUse: View{
    @State var scene:SCNScene? = .init(named: "bee normal.scn")
    @State var r = 30.2
var body: some View {
        
        GeometryReader { GeometryProxy in
            TabView {
                ///Presentation ISIB et mise en garde sur l'utilisation de l'application

                Tuto0()
                .frame(width: GeometryProxy.size.width, height: GeometryProxy.size.height, alignment: .center)
                .background(Color.clear)
                .tabItem {}
                
                ///Tuto 1... les joueurs
                Tuto1()
                .frame(width: GeometryProxy.size.width, height: GeometryProxy.size.height)
                
                .tabItem {}
                Tuto2()
                .frame(width: GeometryProxy.size.width, height: GeometryProxy.size.height)
                .background{
                    Image("backHP")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                }
                .tabItem {}
                
            
            }
            .edgesIgnoringSafeArea(.all)
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .overlay {
                    VStack {
                    Spacer()
                    SwipeActionView()
                }.frame(width: GeometryProxy.size.width, height: GeometryProxy.size.height)
                    .background(Color.clear)
            }
        }
        
    }
    
    
    //view Builders
    @ViewBuilder
    func Tuto0() -> some View{
        GeometryReader { GeometryProxy in
            VStack {
                Image("ISIB_Logo2").resizable().scaledToFit()
                Text("Application pour le cous de developpement d'application mobile. Voici un petit tutoriel pour la prendre en main :-)").multilineTextAlignment(.center).fontWeight(.bold)
                    .monospaced(true)
                    .padding(.vertical, 30)
                    Divider()
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func Tuto1() -> some View {
        GeometryReader { GeometryProxy in
            VStack {
                ZStack {
                    Image("backHP")
                        .resizable()
                        .frame(width: 200, height: 250)
                        .border(.red)
                        .cornerRadius(30)
                        .rotationEffect(.degrees(RandomAngle()))
                    Image("hp1")
                        .resizable()
                        .frame(width: 200, height: 250)
                        .cornerRadius(30).border(.red)
                        .rotationEffect(.degrees(RandomAngle()))
                    Image("1")
                        .resizable()
                        .frame(width: 200, height: 250)
                        .cornerRadius(30).border(.red)
                        .rotationEffect(.degrees(RandomAngle()))
                }.frame(width:GeometryProxy.size.width, height: 400, alignment: .center)
                    .background(.ultraThinMaterial)
                VStack(spacing:40){
                    Text("Les cartes representent les personnages disponibles. Une carte est chosie en début de jeu et nous suit tout au long de l'aventure. Les cartes spéciales donnent juste des informations sur les joueurs, et les autres cartes nous permettent de jouer dans la peau d'un personnage: Serez vous sorcier ou maitre des postions ?")
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                        .monospaced()
                        .padding(.vertical, 30)
                        .fontWeight(.semibold)
                    Divider()
                }
                Spacer()
            }
        }
        
    }
    
    @ViewBuilder
    func Tuto2()->some View{
        GeometryReader { GeometryProxy in
            VStack {
               //On affiche l'abeille en 3D
                VStack {
                    CardViewEntry(scene: $scene)
                        .frame(height: GeometryProxy.size.height/2)
                    Text("Les abeilles bleues de monsieur Nicolas peuvent etre farouches (sans doutes à cause de leur physique difficile), mais leur couleur bleue donne une saveur épique aux filtres d'amour... aucun trucage  c'est magique").fontWeight(.semibold)
                        .monospaced()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                }
                .padding(.bottom, 20)
                .background(Material.ultraThinMaterial)
                .cornerRadius(30)
                Spacer()
            }
        }
    }
    
    
    @ViewBuilder
    func SwipeActionView()->some View{
        HStack{
            Text("< < < < <  Swipe to continue ").padding(.all)
                //.scaleEffect(r)
        }
        .background(Material.ultraThinMaterial)
        .cornerRadius(30)
        .padding(.bottom, 20)
        .offset(x:r)
        .onAppear {
            withAnimation(.loading().delay(0)) {
                    r = 0.0
                }
            }
    }
    
   
    
}


struct HowToUse_Previews: PreviewProvider {
    static var previews: some View {
        HowToUse()
    }
}

func RandomAngle() -> Double{
    return Double.random(in: 2.0...80.0)
}
