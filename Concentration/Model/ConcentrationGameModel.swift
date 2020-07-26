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
    
    var secondIndex: Int?
    var firstTimeSeenCardsArray = [Int]()
    var secondTimeSeenCardsArray = [Int]()
    var score = 0
    var cardFlipsCount = 1

    var totalFlipsCount = 0

    var firstCardFlippedOnDate: Date?
    var secondCardFlippedOnDate: Date?
    var timeBetweenFlips: DateComponents?
    
    func chooseCard(at index: Int) {
        totalFlipsCount += 1
        if let matchedIndex = indexOfOneAndOnlyFaceUpCard, matchedIndex != index {
            if cards[matchedIndex].identifier == cards[index].identifier {
                cards[matchedIndex].isMatched = true
                cards[index].isMatched = true
            }
            secondIndex = indexOfOneAndOnlyFaceUpCard
            cards[index].isFaceUp = true
            getTimeOfCardFlips(from: index)
            indexOfOneAndOnlyFaceUpCard = nil
            
        } else {
            for flipDownIndex in cards.indices {
                cards[flipDownIndex].isFaceUp = false
            }
            cards[index].isFaceUp = true
            indexOfOneAndOnlyFaceUpCard = index
            getTimeOfCardFlips(from: index)
        }
        changeScoreDependingOnMatchesAndMismatches(from: index)
        cards[index].wasSeen = true
    }
    
    func getTimeOfCardFlips(from index: Int) {
        // Get the user's current calendar and its components
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: Date())
        
        //Set date values for each corresponding card
        if let matchedIndex = indexOfOneAndOnlyFaceUpCard, matchedIndex != index {
            secondCardFlippedOnDate = calendar.date(from: components)
        } else {
            firstCardFlippedOnDate = calendar.date(from: components)
        }
        // If both flips have date values, check the difference in time between flips
        changeScoreDependingOnTimeBetweenFlips(basedOn: calendar)
    }
    
    func changeScoreDependingOnTimeBetweenFlips(basedOn calendar: Calendar) {
        if firstCardFlippedOnDate != nil && secondCardFlippedOnDate != nil {
            timeBetweenFlips = calendar.dateComponents([.hour,. minute, .second], from: firstCardFlippedOnDate!, to: secondCardFlippedOnDate!)
            if let difference = timeBetweenFlips {
                // second card is touched
                if difference.second! > 5 {
                    score -= 5
                }
                // first card is touched
                else if difference.second! < -5 {
                    score -= 5
                }
            }
        }
    }
    
    func changeScoreDependingOnMatchesAndMismatches(from index: Int) {
        cardFlipsCount = 1
        if let oneFaceUpCard = secondIndex, oneFaceUpCard != index {
            if cards[oneFaceUpCard].identifier == cards[index].identifier {
                print(cards[oneFaceUpCard].identifier, cards[index].identifier)
                score += 2
            }
            if secondTimeSeenCardsArray.contains(cards[oneFaceUpCard].identifier) && cards[index].identifier != cards[oneFaceUpCard].identifier || cards[index].wasSeen && !cards[index].isMatched {
                score -= 1
            }
            if secondTimeSeenCardsArray.contains(cards[oneFaceUpCard].identifier) && secondTimeSeenCardsArray.contains(cards[index].identifier) && !cards[index].isMatched || cards[index].wasSeen && !cards[index].isMatched {
                score -= 1
            }
            secondIndex = nil
        }
        if cardFlipsCount == 1 {
            addSeenCardsToArrays(from: index)
        } else if cardFlipsCount == 2 && cards[index].wasSeen {
            score -= 1
        }
    }
    
    func addSeenCardsToArrays(from index: Int) {
        if firstTimeSeenCardsArray.contains(cards[index].identifier) {
            cardFlipsCount = 2
            if !secondTimeSeenCardsArray.contains(cards[index].identifier) && !cards[index].wasSeen {
                secondTimeSeenCardsArray.append(cards[index].identifier)
            }
        } else if cardFlipsCount == 1 {
            firstTimeSeenCardsArray.append(cards[index].identifier)
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = CardModel()
            cards += [card, card]
            cards.shuffle()
        }
    }

    func startNewGame() {
        secondIndex = nil
        cardFlipsCount = 1
        score = 0
        firstTimeSeenCardsArray = []
        secondTimeSeenCardsArray = []
        totalFlipsCount = 0
        
        for resetCardIndex in cards.indices {
            cards[resetCardIndex].isFaceUp = false
            cards[resetCardIndex].isMatched = false
            cards[resetCardIndex].wasSeen = false
        }
        cards.shuffle()
    }
    
    var valueInArray = ""
    func setTheme(from dictionary: [String: [String]]) -> [String] {
        let keys = Array(dictionary.keys)
        let randomIndex = Int(arc4random_uniform(UInt32(keys.count)))
        valueInArray = keys[randomIndex]
        var array = [String]()
        if let dictionaryKey = dictionary[valueInArray] {
            array.append(contentsOf: dictionaryKey)
        }
        return array
    }
    
    
    
}
