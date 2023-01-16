//
//  CardViewEntry.swift
//  DevAppMobile
//
//  Created by Jean Hubert ABA'A on 21/10/2022.
//

import SwiftUI
import SceneKit
struct CardViewEntry: UIViewRepresentable {
    @Binding var scene: SCNScene?
    
    func makeUIView(context: Context) -> SCNView{
        let view = SCNView()
        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = true
        view.backgroundColor = .clear
        view.antialiasingMode = SCNAntialiasingMode.multisampling2X
        view.scene = scene
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        
    }
}

