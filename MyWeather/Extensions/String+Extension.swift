//
//  String+Extension.swift
//  MyWeather
//
//  Created by Naveen PaulSingh on 21/02/23.
//

import Foundation

extension String {
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
    }
}

