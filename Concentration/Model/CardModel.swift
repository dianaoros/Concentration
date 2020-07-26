//
//  CardModel.swift
//  Concentration
//
//  Created by Diana Oros on 7/11/20.
//  Copyright © 2020 Diana Oros. All rights reserved.
//

import Foundation

struct CardModel {
    
    var wasSeen = false
    var isFaceUp = false
    var isMatched = false
    var identifier : Int
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        identifier = CardModel.getUniqueIdentifier()
    }

}
