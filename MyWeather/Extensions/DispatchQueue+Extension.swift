//
//  DispatchQueue+Extension.swift
//  MyWeather
//
//  Created by Naveen PaulSingh on 20/02/23.
//

import Foundation

extension DispatchQueue {
    func delay(interval: TimeInterval, closure: @escaping () -> Void) {
         DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
              closure()
         }
    }
}
