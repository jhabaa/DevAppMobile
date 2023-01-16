//
//  Users.swift
//  DevAppMobile
//
//  Created by Jean Hubert ABA'A on 07/11/2022.

// Classe Utilisateur de l'application.
//

import Foundation

struct User:Codable, Hashable {
    var username:String
    var password:String
    var authentificated:Bool = false
    
    init(name:String, pass:String) {
        self.username = name;
        self.password = pass;
    }
}
