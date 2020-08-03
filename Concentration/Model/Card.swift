//
//  CardModel.swift
//  Concentration
//
//  Created by Diana Oros on 7/11/20.
//  Copyright © 2020 Diana Oros. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    var wasSeen = false
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        identifier = Card.getUniqueIdentifier()
    }

}
