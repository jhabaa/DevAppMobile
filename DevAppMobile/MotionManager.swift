//
//  MotionManager.swift
//  DevAppMobile
//
//  Created by Jean Hubert ABA'A on 15/11/2022.
//
import SwiftUI
import Foundation
import CoreMotion


class MotionManager:ObservableObject{
    @Published var manager:CMMotionManager = .init()
    @Published var xValue:CGFloat = 0
   // @Published var currentCard : Card = cards[0]
    func getMotion(){
        print("Start Motion function")
        if !manager.isDeviceMotionActive{
            print("Motion is detected")
            manager.startDeviceMotionUpdates(to: .main) { [weak self] movement, err in
                if let attitude = movement?.attitude{
                    self?.xValue = attitude.roll
                    
                    print(attitude.roll)
                }
                
            }
        }
        
    }
    
    func stopMotion(){
        manager.stopDeviceMotionUpdates()
    }
}
