//
//  Persistance.swift
//  DevAppMobile
//
//  Created by Jean Hubert ABA'A on 07/11/2022.
//

import Foundation
import Combine

final class User_DATA:ObservableObject{
    //ObservableObject est une classe contrainte à la connection externe du model de données avec des vue
    
    //WillChange publisher emet un de ses propriétés @Published qui va changer. Toute vue qui observe une instance de User_DATA sera rechargée quand la valeur de user changera
    @Published var user:User=User.init(name: "", pass: "")
    
    /*
     Nous chageons ou sauvegardons l'utilisateur sur un fichier dans les documents utilisateurs. Nous créons une fonction pour rendre cett accès plus convenu
     */
    private static func fileURL() throws -> URL{
        //On utilise l'instance de la classe du gestionnaire de fichiers de l'utilisateur courant
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("userStore.data")
    }
    
    //Methode de chargement des données
    static func Load(completion:@escaping (Result<User, Error>) -> Void){
        //Nous utilisons DispatchQueue pour choisir si la tache doit s'exécuter en front ou en back
        DispatchQueue.global(qos:.background).async {
            do{
                let fileURL = try fileURL()
                
                //Comme le fichier user.data n'existe pas au premier lancement, on appelle le Completion Handler avec un utilisateur par defaut s'il y a une erreur à l'ouverture du fichier
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(User.init(name: "Stranger", pass: "")))
                    }
                    return
                }
                
                //On decode le fichier disponible  dans une constante locale
                let user_in_file = try JSONDecoder().decode(User.self, from: file.availableData)
                
                //Sur le main queue, on passe le user décodé au Completion Handler
                //On met la longue tache de l'ouverture et du décodage du contenu sur le queue en tache de fond. Une fois fait, on retourne sur le processus principal
                
                DispatchQueue.main.async {
                    completion(.success(user_in_file))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    //Methode de sauvegarde des données
    static func Save(user_to_save:User, completion:@escaping(Result<User, Error>)->Void){
        DispatchQueue.global(qos:.background).async {
            do{
                let data = try JSONEncoder().encode(user_to_save)
                let outFile = try fileURL()
                try data.write(to: outFile)
                DispatchQueue.main.async {
                    completion(.success(user_to_save))
                }
            }
            catch{
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    //Suppression des données persistantes pour deconnexion
    public static func removeData(){
        let fileManager = FileManager.default
        do{
            try fileManager.removeItem(at: fileURL())
        } catch{
            print(error)
        }
    }
    
    //fonction qui vérifie si une carte appartient aux favories
    func favorite(a:Int) -> Bool{
        return true    }
    
    //fonction qui ajoute ou retire une carte aux favoris
    func Add_Del_Favorite(a:Int){
        
    }
    
}
