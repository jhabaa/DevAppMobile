//
//  Card_Fetch.swift
//  DevAppMobile
//
//  Created by Jean Hubert ABA'A on 11/11/2022.
//

import Foundation

let urlServer = "146.59.35.233"
let urlPort:String = "5000"

struct verification : Codable, Hashable{
    var username:String
    var password:String
}

//========================================================================
//============ Récupération des Objects ==================================

var db_objects:[Object] = []
var db_likes:[Int] = [] //tableau qui comporte par utilisateur les idObjects des elements likés
class FetchObjects: ObservableObject {
    @Published var allObjects:[Object]=[]
    @Published var likes : [user_has_object] = []
    @Published var authentificaded : Bool = false
    func fetchObjects(){
        guard let url = URL(string: "http://\(urlServer):\(urlPort)/objects") else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){ [weak self]
            data, _,
            error in
            guard let data = data, error == nil else {
                return
            }
            //convert from JSON
            do{
                let results = try JSONDecoder().decode([Object].self, from: data)
                
                DispatchQueue.main.async {
                    self?.allObjects = results //Non utilisé, mais utile
                    print(results)
                    db_objects = results
                }
            }catch{
                print (error)
            }
        }
        task.resume()
    }
    
    
    //===========Connexion utilisateur ====================================
    
    func connection(credentials:verification) async -> Bool{
        var r:Bool = false
        guard let encoded = try? JSONEncoder().encode(credentials) else{
            return false
        }
        let url = URL(string:"http://\(urlServer):\(urlPort)/connect")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "POST"
        do{
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            print(data)
            //On recupère le résultat de la requête qu'on retourne
            let resultFromFlask = String(decoding:data, as: UTF8.self)
            //print(resultFromFlask)
            return true
            
        } catch{
            return false
        }
    }
    
    //Fonction qui récupère tous les likes
    @Published var users_has_a_like:[user_has_object]=[]
    @Published var current_likes:[Int]=[] //Likes de l'utilisateur en cours
    func GetLikes(current_user:User){
        db_likes.removeAll()
        guard let url = URL(string: "http://\(urlServer):\(urlPort)/likes") else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){ [weak self]
            data, _,
            error in
            guard let data = data, error == nil else {
                return
            }
            //convert from JSON
            do{
                let likes = try JSONDecoder().decode([user_has_object].self, from: data)
                //Il suffit de remplir ensuite le tableau des likes pour le joueur concerné
                    likes.forEach { o in
                        if ((o.user_username == current_user.username && !db_likes.contains(o.object_idobject))){
                            db_likes.append(o.object_idobject)
                        }
                    }
                
                //print("\(self?.current_likes) Sont les likes de \(current_user.username)")
            }catch{
                print (error)
            }
        }
        task.resume()
    }
    
    //like objects
    func like_object(object: user_has_object) async {
        guard let encoded = try? JSONEncoder().encode(object) else{
            return
        }
        let url = URL(string:"http://\(urlServer):\(urlPort)/like")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "POST"
        do{
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            print(data)
            //On recupère le résultat de la requête qu'on retourne
            let resultFromFlask = String(decoding:data, as: UTF8.self)
            print(resultFromFlask)
            DispatchQueue.main.async {
                self.GetLikes(current_user: User(name: object.user_username, pass: ""))
            }
            
        } catch{
            
        }
    }

    
    //dislike objects
    func dislike_object(object: user_has_object) async{
        guard let encoded = try? JSONEncoder().encode(object) else{
            return
        }
        print("Dislike object \(object.object_idobject)")
        let url = URL(string:"http://\(urlServer):\(urlPort)/dislike")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "POST"
        do{
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            print(data)
            //On recupère le résultat de la requête qu'on retourne
            let resultFromFlask = String(decoding:data, as: UTF8.self)
            print(resultFromFlask)
            DispatchQueue.main.async {
                self.GetLikes(current_user: User(name: object.user_username, pass: ""))
            }
            
        } catch{
            
        }
    }
    
    //Fonction qui permet d'enregister un nouvel utilisateur dans la BD
    func add_user(object: User) async {
        guard let encoded = try? JSONEncoder().encode(object) else{
            return
        }
        let url = URL(string:"http://\(urlServer):\(urlPort)/adduser")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "POST"
        do{
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            print(data)
            //On recupère le résultat de la requête qu'on retourne
            let resultFromFlask = String(decoding:data, as: UTF8.self)
            print(resultFromFlask)
            DispatchQueue.main.async {
                
            }
            
        } catch{
            
        }
    }
}

