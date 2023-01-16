//
//  LoginScreen.swift
//  DevAppMobile
//
//  Created by Jean Hubert ABA'A on 29/10/2022.
//

import SwiftUI
import AVKit
import AVFoundation


struct PlayerView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }

    func makeUIView(context: Context) -> UIView {
        return LoopingPlayerUIView(frame: .zero)
    }
}

class LoopingPlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Load the resource -> h
        let fileUrl = Bundle.main.url(forResource: "vid1", withExtension: "mp4")!
        let asset = AVAsset(url: fileUrl)
        let item = AVPlayerItem(asset: asset)
        // Setup the player
        let player = AVQueuePlayer()
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        // Create a new player looper with the queue player and template item
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        playerLayer.speed = player.rate
        // Start the movie
        player.play()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}

//extension pour l'effet de transparence
extension View{
    func blurSheet<Content: View>(_ style: AnyShapeStyle, show: Binding<Bool>, onDismiss: @escaping ()->(), @ViewBuilder content: @escaping ()-> Content) -> some View{
        self
            .sheet(isPresented: show, onDismiss: onDismiss){
                content()
                    .background(RemoveBackgroundColorSheet())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background{
                        Rectangle()
                            .fill(style)
                            .ignoresSafeArea(.container, edges: .all)
                    }
            }
    }
}
fileprivate struct RemoveBackgroundColorSheet:UIViewRepresentable{
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
}

struct LoginScreen: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var current_user:User_DATA
    @State var username: String = ""
    @State var password: String = ""
    @State var v_password: String = ""
    @State var pseudo: String = ""
    @State var connexionBtn:String = "Connexion"
    @State var loginForm:Bool = false
    @State var registrer:Bool=false
    @State var connectionSuccedd:Bool = false
    @State var connexionText = "Connexion reussie"
    @State var signInView = false
    @State var StackPosition:Double = 0.0
    @State var passed:Bool = false
    @FocusState private var keyboardIsUP:Bool
    @State var currentPage = 0
    var body: some View {
        GeometryReader { GeometryProxy in
            
                VStack(alignment: .center, spacing: 20) {
                    //-- Titre de l'application --
                    VStack(alignment: .center, content: {
                        HStack(alignment: .center) {
                            Text("Le")
                                .font(Font.custom("HARRYP", size: 40))
                                .offset(y:30)
                        }
                        Text("Grimoire")
                            .font(Font.custom("HARRYP", size: 150))
                            
                            
                    }).frame(width: .infinity)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top,40)
                        
                    Spacer()
                        
                    
                }
                .frame(width: GeometryProxy.size.width, height: GeometryProxy.size.height)
                .overlay(alignment: Alignment.bottom, content: {
                    VStack{
                        Text("Connexion")
                            .fontWeight(.heavy)
                            .fontDesign(.monospaced)
                            .font(.title)
                    }.frame(width: GeometryProxy.size.width, height: 100, alignment: .center)
                        .onTapGesture {
                            //On affiche le sheet de connexion
                            loginForm = true
                        }
                        .background(.ultraThinMaterial)
                })
                .blurSheet(.init(.ultraThinMaterial), show: $loginForm){
                    
                }content: {
                    Capsule().fill(.gray).frame(width: 50, height: 10)
                        .padding(3)
                        
                    VStack{
                        LoginBloc()
                    }.presentationDetents([.height(300)])
                }

                //SignIn Page
            signInView ?
                SignInView()
            :
            nil
            
        }
            .background(PlayerView()
                .blur(radius: 0))
            
            .ignoresSafeArea(.all)
            .onAppear{
                username = current_user.user.username
                password = current_user.user.password
            }
    }
    func SlidePageToLeft(){
        currentPage += 1
        StackPosition += UIScreen.main.bounds.width
    }
    func SignInView()->some View{
        GeometryReader { GeometryProxy in
            
            LazyHStack(spacing:0){
                //Validation de l'adresse mail
                VStack(alignment: HorizontalAlignment.center) {
                    Image("userName")
                    Text("Inscrivez votre pseudo")
                        .opacity(0.6)
                    TextField(
                        "Pseudo",
                        text: $username
                    )
                    .focused($keyboardIsUP)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .multilineTextAlignment(.center)
                    .padding(15)
                    .background(Capsule().fill(Material.ultraThinMaterial).shadow(color:.gray,radius: 2))
                    .padding(10)
                }
                .frame(width:GeometryProxy.size.width, height: GeometryProxy.size.height, alignment: .center)
                

                //Creation du mot de passe
                VStack(alignment: HorizontalAlignment.center) {
                    Image("password")
                    Text("La sécurité c'est important un mot de passe est requis")
                        .opacity(0.6)
                    
                    TextField(
                        "mot de passe",
                        text: $password
                    )
                    .focused($keyboardIsUP)
                    .multilineTextAlignment(.center)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(15)
                    .background(Capsule().fill(Material.ultraThinMaterial).shadow(color:.gray,radius: 2))
                    .padding(10)
                    
                    SecureField("Entrer à nouveau le mot de passe", text: $v_password)
                    //.background(.regularMaterial)
                        .focused($keyboardIsUP)
                        .multilineTextAlignment(.center)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(15)
                        .background(Capsule().fill(Material.ultraThinMaterial)
                            .shadow(color:.gray,radius: 2))
                        .padding(10)
                        .foregroundColor(!passed ? Color.red : Color.white)
                    
                    //Bouton validation
                    if (passed){
                        Text("Valider mon inscription")
                            .font(.title2)
                            .bold()
                            .padding(15)
                            .background(Capsule().fill(Color.blue.opacity(0.8))
                                .shadow(color:.white,radius: 2))
                            .padding(10)
                            .onTapGesture{
                                current_user.user.username = username
                                current_user.user.password = password
                                Task{
                                    await FetchObjects().add_user(object: .init(name: username, pass: password))
                                    signInView.toggle()
                                    current_user.user.authentificated = await FetchObjects().connection(credentials: .init(username: username, password: password))
                                    await FetchObjects().GetLikes(current_user: current_user.user)
                                }
                            }
                    }
                    
                    
                }
                .frame(width:GeometryProxy.size.width, height: GeometryProxy.size.height, alignment: .center)
                .onChange(of: v_password) { newValue in
                    withAnimation (.spring(response: 1, dampingFraction: 0.3, blendDuration: 1.3)) {
                        passed = Password_verification(a: v_password, b: password)
                    }
                    
                }
            }
            .frame(height: GeometryProxy.size.height)
            .offset(x:-StackPosition)
            .offset(y : keyboardIsUP ? -300 : 0)
            .animation(.easeIn(duration: 0.6), value: keyboardIsUP)
            
        }
        .background(.ultraThinMaterial)
        .overlay(alignment:.bottom){
            if currentPage != 1{
                Image(systemName: "chevron.right")
                    .padding(5)
                    .background(Circle().fill(.white))
                    .scaleEffect(3)
                    .offset(x:150)
                    .onTapGesture {
                        withAnimation (.spring(response: 1, dampingFraction: 1.0, blendDuration: 0.4)){
                            SlidePageToLeft()
                        }
                    }
                .font(.title2)
                .padding(40)
                .foregroundColor(.black)
            }
        }
    }
    
    @ViewBuilder
    func LoginNotification() -> some View{
        GeometryReader { GeometryProxy in
            VStack(alignment: .center) {
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func LoginBloc() -> some View{
        GeometryReader { GeometryProxy in
            VStack(alignment: .center, spacing:0){

                TextField(
                    "Utilisateur ou email",
                        text: $username
                )
                .multilineTextAlignment(.center)
                .padding(15)
                .background(Capsule().fill(.thinMaterial).shadow(radius: 2))
                .padding(10)
                
                
                SecureField("Mot de passe", text: $password)
                //.background(.regularMaterial)
                    .multilineTextAlignment(.center)
                    .padding(15)
                    .background(Capsule().fill(.thinMaterial).shadow(radius: 2))
                    .padding(10)
                
                Button("Connexion"){
                    current_user.user.username = username
                    current_user.user.password = password
                        
                    Task {
                        current_user.user.authentificated = await FetchObjects().connection(credentials: .init(username: username, password: password))
                        await FetchObjects().GetLikes(current_user: current_user.user)
                    }
                        
                    
                    
                }
                .padding(10)
                .background(Rectangle().fill(.ultraThickMaterial).shadow(radius: 3))
                HStack(alignment: .center) {
                    Button {
                        //On desactive la page de login
                        current_user.user.authentificated = true
                    } label: {
                        Text("Continuer sans s'enregister")
                            .underline()
                    }

                    Spacer()
                    Button("Nouveau Compte"){
                        signInView.toggle()
                        loginForm.toggle()
                    }
                    .buttonBorderShape(.automatic)
                }
                .font(.caption)
                    .padding(.top, 40)
                    .padding(.horizontal, 20)
                
                if registrer {
                    SecureField("Entrer à nouveau le mot de passe", text: $password)
                    //.background(.regularMaterial)
                        .padding(15)
                        .background(.thinMaterial)
                        .cornerRadius(100)
                        .padding(20)
                }
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .font(.title2)
            .cornerRadius(30)
        }
    }
}


func LoginAction(loginText:inout String, loginBlocState:inout Bool){
    
    loginText = "Valider"
    print("Bouton valider activé")
    loginBlocState = true
    
}

func Password_verification(a:String, b:String)->Bool{
    return (a == b)
}



