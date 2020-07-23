//
//  ConcentrationGameModel.swift
//  Concentration
//
//  Created by Diana Oros on 7/11/20.
//  Copyright © 2020 Diana Oros. All rights reserved.
//

import Foundation

class ConcentrationGameModel {
    
    var cards = [CardModel]()
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(at index: Int) {
        
        if let matchedIndex = indexOfOneAndOnlyFaceUpCard, matchedIndex != index {
            if cards[matchedIndex].identifier == cards[index].identifier {
                cards[matchedIndex].isMatched = true
                cards[index].isMatched = true
            }
            cards[index].isFaceUp = true
            indexOfOneAndOnlyFaceUpCard = nil
            
        } else {
            for flipDownIndex in cards.indices {
                cards[flipDownIndex].isFaceUp = false
            }
            cards[index].isFaceUp = true
            indexOfOneAndOnlyFaceUpCard = index
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = CardModel()
            cards += [card, card]
            cards.shuffle()
        }
    }

    //TODO: Reset game

}
