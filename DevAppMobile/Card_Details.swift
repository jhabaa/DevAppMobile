//
//  Card_Details.swift
//  DevAppMobile
//
//  Created by Jean Hubert ABA'A on 11/11/2022.
//

import SwiftUI

struct Card_Details: View {
    @Environment(\.scenePhase) private var scenePhase
    @State var card:Object
    @Binding var show_Details:Bool
    @Namespace var namespace:Namespace.ID
    @EnvironmentObject var current_user:User_DATA
    @State var credits:Bool = false
    @StateObject var motionSensor:MotionManager = .init()
    var body: some View {
        GeometryReader { GeometryProxy in
            let frameY = GeometryProxy.frame(in: .named("SCROLL")).minY
            
            ScrollView {
                VStack{
                    DetailImageView()
                }
                .frame(width: GeometryProxy.size.width, height: 300 + (frameY > 0 ? frameY : 0))
                LazyVStack(spacing: 1, pinnedViews: [.sectionHeaders]) {
                    Section {
                        HStack{
                            Text("\(card.image)")
                                .font(.custom("name", size: 30))
                                .bold()
                            Spacer()
                            Image(systemName:db_likes.contains(card.idobject) ? "heart.fill" : "heart")
                                .foregroundColor(db_likes.contains(card.idobject) ? Color.yellow : Color.white)
                                .scaleEffect(1.9)
                                .onTapGesture {
                                    Task{
                                        if !(db_likes.contains(card.idobject)){
                                            await FetchObjects().like_object(object: user_has_object.init(user_username: current_user.user.username, object_idobject: card.idobject))
                                        }else{
                                            await FetchObjects().dislike_object(object: user_has_object.init(user_username: current_user.user.username, object_idobject: card.idobject))
                                        }
                                        //await FetchObjects().like_object(object: user_has_object.init(user_username: current_user.user.username, object_idobject: card.idobject))
                                    }
                                        
                                    
                                }
                                
                        }
                        .padding(.horizontal, 50)
                        .padding(.vertical)
                    }
                    //Ingredients
                    GroupBox {
                        Text("\(card.ingredients)")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                    } label: {
                        Text("Ingrédients")
                            .foregroundColor(.yellow)
                            .font(.largeTitle)
                    }

                    
                        
                    
                    // Description Text
                    
                    Text("\(card.description)")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
            }
            .coordinateSpace(name: "SCROLL")
            .edgesIgnoringSafeArea(.all)
            .frame(width: GeometryProxy.size.width, height: GeometryProxy.size.height, alignment: .center)
            .overlay {
                HStack {
                    Image(systemName: "chevron.left")
                        .scaleEffect(1.5)
                        .padding()
                        .onTapGesture {
                            withAnimation {
                                show_Details.toggle()
                            }
                           
                        }
                    Spacer()
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .scaleEffect(1.5)
                        .padding()
                        .onTapGesture {
                            credits.toggle()
                        }
                        
                }
                .padding()
                .zIndex(2)
                .offset(y:-380)
            }
            
            .alert(isPresented: $credits) {
                        Alert(title: Text("Crédits du Grimoire"),
                              message: Text("\(card.image) a été écrit par \(card.author) et est disponible sur \(card.link)"),
                              primaryButton: .default(Text("Fermer")), secondaryButton: .default(Text("plus"), action: {
                           
                        }))
                    }
        }
        .background{
            VStack{
                Circle().scale(0.5).fill(.white.opacity(0.5))
                    .blur(radius: 30, opaque: false)
                    .shadow(color: .blue, radius: 90)
                    .offset(x:-80,y:-300)
                Circle().scale(0.2).fill(.green.opacity(0.5))
                    .blur(radius: 50, opaque: false)
                    .shadow(color: .white, radius: 90)
                    
                
            }
            .frame(width: 450, height: .infinity)
            .background(.black)
        }
        .foregroundColor(.white)
        .animation(.easeInOut(duration: 1.0), value: show_Details)
        .tint(.black)
        .onAppear{
            
            Task{
                motionSensor.getMotion()
                print(db_likes)
            }
            
        }
        .onDisappear(perform: motionSensor.stopMotion)
        .onChange(of: db_likes) { newValue in
            show_Details.toggle()
            show_Details.toggle()
        }
        
    }
    
    @ViewBuilder
    func DetailImageView() -> some View{
        GeometryReader { GeometryProxy in
            let frameY = GeometryProxy.frame(in: .named("SCROLL")).minY
            
            AsyncImage(url: URL(string: "http://\(urlServer):\(urlPort)/get-image?name=\(card.type)") , content: { image in
                image.resizable().scaledToFit()
            }, placeholder: {
                ProgressView()
            })
                .frame(width: GeometryProxy.size.width, height: (GeometryProxy.size.height + (frameY > 0 ? frameY : 0)))
                .clipped()
                .matchedGeometryEffect(id: "card_image", in: namespace, properties: MatchedGeometryProperties.size)
                .offset(x:motionSensor.xValue*80)
                .overlay(content: {
                    Rectangle().fill(.linearGradient(colors: [
                        .black.opacity(0),
                        .black.opacity(0.2),
                        .black.opacity(0.4),
                        .black.opacity(0.6),
                        .black.opacity(1.8)
                    ], startPoint: .top, endPoint: .bottom))
                })
                .edgesIgnoringSafeArea(.all)
                .background {
                    Text("\(card.image)")
                        .font(Font.custom("HARRYP", size: AdjustTextToWidth(word: card.image)))
                        .scaleEffect(1 + (frameY > 0 ? frameY/4 : 0))
                        .shadow(color: .black, radius: 2, x: 2, y: 2)
                        .clipped()
                        .offset(x:-motionSensor.xValue*50)
                    
                        
                        
                }
        }
    }
}

func AdjustTextToWidth(word:String) -> CGFloat{
    return CGFloat((450/word.count) + 110)
}
