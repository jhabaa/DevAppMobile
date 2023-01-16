//
//  Sorts.swift
//  DevAppMobile
//
//  Created by Jean Hubert ABA'A on 01/11/2022.
//

import SwiftUI

struct Sorts: View {
    var body: some View {
        GeometryReader { GeometryProxy in
            ScrollView{
     
                Sort()
                    .onTapGesture {
                        //On affiche la fiche en entier
                    }
                    
            }.frame(width: GeometryProxy.size.width, height: GeometryProxy.size.height)
                //.background(Material.thinMaterial)
                .background(Image("tv1").resizable().ignoresSafeArea(edges: .all))
                
        }
    }
    
    @ViewBuilder
    func Sort() -> some View{
        LazyVGrid(columns: [GridItem(.fixed(90)), GridItem(.flexible())]){
            Image("hp1").resizable().scaledToFit()
 
            VStack(){
                Text("Nom du Sort").font(.title2)
                Text("Desciption du sort").font(.caption)
            }
            .foregroundColor(.white)
        }.frame(width: 400, height: 100)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            
    }
}

struct Sorts_Previews: PreviewProvider {
    static var previews: some View {
        Sorts()
    }
}
