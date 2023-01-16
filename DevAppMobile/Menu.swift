//
//  Menu.swift
//  DevAppMobile
//
//  Created by Jean Hubert ABA'A on 28/10/2022.
//

import SwiftUI

struct Menu: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var current_user:User_DATA
    //@State var current_user:User = User(name:"hean", pass: "hean")
    @State var sort:Bool = true
    @State var menu:Bool =  true
    @State var objects = [Object]()
    @State var current_card:Object = Object.init()
    @State var show_Details:Bool = false
    @Namespace var namespace:Namespace.ID
    @StateObject var motionSensor:MotionManager = .init()
    @StateObject var fetchObjects = FetchObjects()
    @State var S:CGSize = CGSize.init()
    var body: some View {
        GeometryReader { GeometryProxy in
            let Size = GeometryProxy.size
            let frameY = GeometryProxy.frame(in: .named("SCROLL")).minY  // Valeur de scroll sur Y
            let minY = GeometryProxy.frame(in: .named("SCROLL")).minY + GeometryProxy.safeAreaInsets.top
            ZStack {
                ScrollView(showsIndicators: false) {
                    //Picture
                    VStack{
                        ArtWork(proxyScroll: Size)
                        //LogOut button
                        
                        Button {
                            User_DATA.removeData()
                            current_user.user.authentificated = false
                        } label: {
                            Text("Déconnexion").font(.callout)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 45)
                                .padding(.vertical, 12)
                        }.background {
                            Capsule().fill(.blue.opacity(0.9).gradient)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                        .offset(y: minY > 10 ? -(minY) : -50)
                        
                        //Hello text
                        VStack{
                            Text("Grimoires")
                                .font(Font.custom("HARRYP", size: 40,relativeTo: .title))
                                .fontWeight(.heavy)
                                .padding(.top, 20)
                                .offset(y:50)
                            
                                
                                ///Text("\(current_user.user.username == "" ? "Etranger" : current_user.user.username )")
                                  ///  .font(Font.custom("HARRYP", size: 60,relativeTo: .title))
                                /*
                                if current_user.user.username != "Stranger"{
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color.accentColor)
                                        .scaleEffect(2.0)
                                }
                                */
                        }.foregroundColor(.white)
                            //.offset(y:menu ? 0 : -200 )
                        
                        VStack{
                            //sort Page
                            SortList()
                        }.padding(.top, 40)
                        
                            
                    }
                    .overlay(alignment: .top, content: {
                        HeaderView(proxyScroll: Size)
                    })
                

                }
                    .coordinateSpace(name: "SCROLL")
                    .foregroundColor(.white.opacity(0.8))
                    
                
                //Detail view
                show_Details ?
                Card_Details(card: current_card, show_Details: $show_Details)
                    .frame(width: .infinity, height: 1000)
                :
                nil
            }
               
        }
        .background{
            VStack{
                Circle().scale(0.5).fill(.white.opacity(0.5))
                    .blur(radius: 30, opaque: false)
                    .shadow(color: .blue, radius: 90)
                    .offset(x:-80,y:-300)
                
            }
            .frame(width: 450, height: .infinity)
            .background(.black)
        }
        .onAppear{
            Task{
                await fetchObjects.fetchObjects()
                await fetchObjects.GetLikes(current_user: current_user.user)
                print(db_objects)
            }
        }
        .onChange(of: db_likes) { newValue in
            Task{
                show_Details.toggle()
                show_Details.toggle()
            }
            
        }
        
    }
    @ViewBuilder
    func ArtWork(proxyScroll:CGSize)->some View{
        GeometryReader { Proxy in
            let minY = Proxy.frame(in: .named("SCROLL")).minY
            var progress = minY / (proxyScroll.height * 0.6)
            VStack{
                Image("hean")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxyScroll.width, height: proxyScroll.height + (minY > 0 ? minY : 0))
                    .clipped()
                    .overlay(content: {
                        ZStack (alignment: .center, content: {
                            Rectangle().fill(.linearGradient(colors: [.black.opacity(0 - progress),
                                                                      .black.opacity(0.1 - progress),
                                                                      .black.opacity(0.3 - progress),
                                                                      .black.opacity(0.5 - progress),
                                                                      .black.opacity(0.7 - progress),
                                                                      .black.opacity(1),]
                                                             , startPoint: .top, endPoint: .bottom))
                            VStack (spacing: 0, content: {
                                Text("\(current_user.user.username == "" ? "Etranger" : current_user.user.username )")
                                    .font(Font.custom("HARRYP", size: AdjustTextToWidth(word: "Hean"),relativeTo: .title))
                            })
                            .opacity(minY == 0 ? 1 : (1 + progress))
                            .offset(y: -minY)
                            
                        })
                    })
                    .offset(y : -minY) // L'image reste figée
            }.frame(height: Proxy.size.height * 40 + Proxy.safeAreaInsets.top)
        }
        
    }
    
    @ViewBuilder
    func HeaderView(proxyScroll:CGSize)->some View{
        GeometryReader { Proxy in
            let minY = Proxy.frame(in: .named("SCROLL")).minY
            var progress = minY / (proxyScroll.height * 0.6)
            var Titleprogress = minY / (proxyScroll.height * 0.45)
            HStack(alignment: .center){
                Spacer()
                Text(current_user.user.username)
                    .font(.title2)
                    .padding(.horizontal, 45)
                    .padding(.vertical, 10)
                    .background(.black)
                    .clipped()
                    .cornerRadius(20)
                    .offset(y: -Titleprogress > 0.75 ? 0 : -100)
                    .animation(.easeIn(duration: 0.25), value: -Titleprogress > 0.75)
                Spacer()
            }
            .offset(y:-minY)
        }
        
        
    }
    
    
    @ViewBuilder
    func SortList()->some View{
        VStack{
            
            List(db_objects, id: \.idobject) { item in
                        VStack(alignment: .leading) {
                            Text(item.image)
                                .font(.headline)
                            Text(item.author)
                        }
                    }
            
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1)], spacing: 20, pinnedViews: .sectionHeaders) {
                    
                    ForEach(db_objects, id: \.self) { card in
                        
                        //carte de sort
                        ZStack {
                            AsyncImage(url: URL(string: "http://\(urlServer):\(urlPort)/get-image?name=\(card.type)") , content: { image in
                                image.resizable().scaledToFit()
                            
                            }, placeholder: {
                                ProgressView()
                            })
                                .matchedGeometryEffect(id: "card_image", in: namespace, properties: MatchedGeometryProperties.size)
                            
                            VStack(alignment: .leading, content: {
                                Spacer()
                                
                                Text(card.image)
                                    .font(.title2)
                                    .bold()
                                
                                HStack{
                                    Text("\(card.type)")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.9))
                                    Spacer()
                                    Image(systemName:db_likes.contains(card.idobject) ? "heart.fill" : "heart")
                                        .foregroundColor(db_likes.contains(card.idobject) ? Color.yellow : Color.white)
                                        .scaleEffect(db_likes.contains(card.idobject) ? 1.3 : 1)
                                        .animation(Animation.easeIn(duration: 1.0), value: db_likes.contains(card.idobject))
                                }
                                
                                
                            })
                            .padding()
                        }
                        .frame(width:200)
                        .foregroundColor(.white)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .shadow(radius: 2)
                        .onTapGesture(count:2) {
                            //action to like a card
                            Task{
                                if !(db_likes.contains(card.idobject)){
                                    await FetchObjects().like_object(object: user_has_object.init(user_username: current_user.user.username, object_idobject: card.idobject))
                                }else{
                                    await FetchObjects().dislike_object(object: user_has_object.init(user_username: current_user.user.username, object_idobject: card.idobject))
                                }
                                //await FetchObjects().like_object(object: user_has_object.init(user_username: current_user.user.username, object_idobject: card.idobject))
                            }
                        }
                        .onTapGesture(count:1) {
                            current_card = card
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 2.0, blendDuration: 0.5)) {
                                show_Details.toggle()
                            }
                        }
                        
                    }
                    
                }
            
        }
    }
    @ViewBuilder
    func NavBar()->some View{
        GeometryReader { GeometryProxy in
                HStack(alignment: .top){
                    Image(systemName: "chevron.left")
                    Text("Retour")
                }
                .foregroundColor(.white)
                .padding()
                .background{
                    Capsule().fill()
                }
                .onTapGesture {
                    withAnimation {
                        menu = true
                        sort = false
                    }
                    
                    
                }
                .padding()
                Spacer()
            
            .frame(width: .infinity )
        }
    }
    

    
    @ViewBuilder
    func SortView() -> some View{
        GeometryReader { GeometryProxy in
            
        }
        .background()
    }
    
    //Navigation and links builder
    @ViewBuilder
    func Navigation_links() -> some View {
            HStack(alignment:.center, spacing: 30) {
                
                VStack{
                    Image(systemName: "flame")
                        .resizable()
                        .scaledToFit()
                        .padding(5)
                }.frame(width:40)
                    .background{
                        Circle().fill( sort ? .ultraThinMaterial : .bar)
                            .scaledToFill()
                        }
                
                VStack{
                    Image(systemName: "person.2.crop.square.stack")
                        .resizable()
                        .scaledToFit()
                        .padding(5)
                }.frame(width:40)
                    .background{
                        Circle().fill( sort ? .ultraThinMaterial : .bar)
                            .scaledToFill()
                        }
            }
            .padding(20)
        
    }
        
}

struct CardsView:View{
    @State var sort:Bool = true
    @State var current_card:Object = Object.init()
    @StateObject var current_user = User_DATA()
    @State var show_Details:Bool = false
    @Namespace var namespace:Namespace.ID
    @StateObject var motionSensor:MotionManager = .init()
    var body: some View{
        GeometryReader { GeometryProxy in
            

            

        }
        .background{
            VStack{
                Circle().scale(0.5).fill(.white.opacity(0.5))
                    .blur(radius: 30, opaque: false)
                    .shadow(color: .green, radius: 90)
                    .offset(x:-80,y:-300)
                
            }
            .frame(width: 450, height: .infinity)
            .background(.black)
        }
        .foregroundColor(.white.opacity(0.8))
 
    }
   
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
        //NavBar()
        //CardsView()
    }
}


