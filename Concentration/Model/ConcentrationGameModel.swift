//
//  ConcentrationGameModel.swift
//  Concentration
//
//  Created by Diana Oros on 7/11/20.
//  Copyright © 2020 Diana Oros. All rights reserved.
//

import Foundation

struct ConcentrationGameModel {
    
    private(set) var cards = [Card]()
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
        }
        set {
            for index in cards.indices {
                //Turn all cards face down except for indexOfOneAndOnlyFaceUpCard
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    private var secondIndex: Int?
    private var firstTimeSeenCardsSet = Set<Card>()
    private var secondTimeSeenCardsSet = Set<Card>()
    private(set) var score = 0
    private var cardFlipsCount = 1

    private(set) var totalFlipsCount = 0

    private var firstCardFlippedOnDate: Date?
    private var secondCardFlippedOnDate: Date?
    private var timeBetweenFlips: DateComponents?
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards.")
        
        totalFlipsCount += 1
        if let matchedIndex = indexOfOneAndOnlyFaceUpCard, matchedIndex != index {
            if cards[matchedIndex] == cards[index] {
                cards[matchedIndex].isMatched = true
                cards[index].isMatched = true
            }
            secondIndex = indexOfOneAndOnlyFaceUpCard
            cards[index].isFaceUp = true
            getTimeOfCardFlips(from: index)
            
        } else {
            indexOfOneAndOnlyFaceUpCard = index
            getTimeOfCardFlips(from: index)
        }
        changeScoreDependingOnMatchesAndMismatches(from: index)
        cards[index].wasSeen = true
    }
    
    mutating private func getTimeOfCardFlips(from index: Int) {
        // Get the user's current calendar and its components
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: Date())
        
        //Set date values for each corresponding card
        if indexOfOneAndOnlyFaceUpCard == nil {
            secondCardFlippedOnDate = calendar.date(from: components)
        } else {
            firstCardFlippedOnDate = calendar.date(from: components)
        }
        // If both flips have date values, check the difference in time between flips
        changeScoreDependingOnTimeBetweenFlips(basedOn: calendar)
    }
    
    mutating private func changeScoreDependingOnTimeBetweenFlips(basedOn calendar: Calendar) {
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
    
    mutating private func changeScoreDependingOnMatchesAndMismatches(from index: Int) {
        cardFlipsCount = 1
        if let matchedIndex = secondIndex, matchedIndex != index {
            if cards[matchedIndex] == cards[index] {
                print(cards[matchedIndex], cards[index])
                score += 2
            }
            if secondTimeSeenCardsSet.contains(cards[matchedIndex]) && cards[index] != cards[matchedIndex] || cards[index].wasSeen && !cards[index].isMatched {
                score -= 1
            }
            if secondTimeSeenCardsSet.contains(cards[matchedIndex]) && secondTimeSeenCardsSet.contains(cards[index]) && !cards[index].isMatched || cards[index].wasSeen && !cards[index].isMatched {
                score -= 1
            }
            secondIndex = nil
        }
        if cardFlipsCount == 1 {
            addSeenCardsToSet(from: index)
        } else if cardFlipsCount == 2 && cards[index].wasSeen {
            score -= 1
        }
    }
    
    mutating private func addSeenCardsToSet(from index: Int) {
        if firstTimeSeenCardsSet.contains(cards[index]) {
            cardFlipsCount = 2
            if !secondTimeSeenCardsSet.contains(cards[index]) && !cards[index].wasSeen {
                secondTimeSeenCardsSet.insert(cards[index])
            }
        } else if cardFlipsCount == 1 {
            firstTimeSeenCardsSet.insert(cards[index])
        }
        print(firstTimeSeenCardsSet)
        print(secondTimeSeenCardsSet)
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards.")

        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
            cards.shuffle()
        }
    }

    mutating func startNewGame() {
        secondIndex = nil
        cardFlipsCount = 1
        score = 0
        firstTimeSeenCardsSet = []
        secondTimeSeenCardsSet = []
        totalFlipsCount = 0
        
        for resetCardIndex in cards.indices {
            cards[resetCardIndex].isFaceUp = false
            cards[resetCardIndex].isMatched = false
            cards[resetCardIndex].wasSeen = false
        }
        cards.shuffle()
    }
    
    var valueInArray = ""
    mutating func setTheme(from dictionary: [String: [String]]) -> [String] {
        let keys = Array(dictionary.keys)
        valueInArray = keys[keys.count.arc4random]
        var array = [String]()
        if let dictionaryKey = dictionary[valueInArray] {
            array.append(contentsOf: dictionaryKey)
        }
        return array
    }
    
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
    
}
