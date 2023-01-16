//
//  Card.swift
//  DevAppMobile
//
//  Created by Jean Hubert ABA'A on 07/11/2022.
//  Classe des cartes. Une carte est une potion ou un sortilège

import Foundation
import SwiftUI

struct Object:Hashable, Decodable{
    var idobject:Int
    var type:String
    var author:String
    var link:String
    var description:String
    //var Card_image:String?
    var image:String
    var ingredients:String
    
    init() {
        self.idobject = 1
        self.type = ""
        self.author = ""
        self.link = ""
        self.description = ""
        self.image = ""
        self.ingredients = ""
    }

}


