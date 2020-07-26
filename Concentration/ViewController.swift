//
//  ViewController.swift
//  Concentration
//
//  Created by Diana Oros on 7/7/20.
//  Copyright © 2020 Diana Oros. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var game = ConcentrationGameModel(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    var emojiArray = [String]()
    var emojiDictionary = [Int: String]()
    var emojiThemes : [String: [String]] =
        [
        "Holloween": ["🎃", "👻", "💀", "🍎", "🍭", "🍬", "🦇", "😈", "🙀", "🤡"],
        "Sports": ["⚽️", "🏀", "🏈", "🎾", "⚾️", "🛹", "⛸", "🥊", "🎿", "🏓"],
        "Players": ["🏂", "🏋🏽‍♀️", "🤼‍♀️", "🤺", "🤸🏿‍♂️", "🤾🏼‍♀️", "🏄🏻‍♂️", "🧗🏾‍♀️", "🚴🏼", "🏊🏾‍♀️"],
        "Animals": ["🐶", "🐱", "🐯", "🦈", "🐬", "🦧", "🦒", "🐿", "🦜", "🕊"],
        "Fruits": ["🍓", "🍏", "🍇", "🍍", "🍌", "🍉", "🍋", "🍒", "🥥", "🥝"],
        "Veggies": ["🥦", "🥬", "🥕", "🥑", "🍆", "🌽", "🧄", "🥔", "🥒", "🌶"],
        "Moon Phases": ["🌝", "🌛", "🌜", "🌚", "🌕", "🌖", "🌗", "🌘", "🌑", "🌒"]
        ]
    
    @IBOutlet weak var flipsLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
        else {
            print("Chosen Card was not in cardButtons array")
        }
        
    }
    
    @IBAction func startNewGame(_ sender: Any) {
        emojiArray = []
        emojiDictionary = [:]
        game.startNewGame()
        emojiArray = game.setTheme(from: emojiThemes)
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.isEnabled = true
            let card = game.cards[index]
            if card.isFaceUp {
                print(card)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                button.setTitle(getEmoji(for: card), for: .normal)
            }
            else {
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                button.setTitle("", for: .normal)
                if button.backgroundColor == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) {
                    button.isEnabled = false
                }
            }
        }
        scoreLabel.text = "Score: \(game.score)"
        flipsLabel.text = "Flips: \(game.totalFlipsCount)"
    }
    
    func getEmoji(for card: CardModel) -> String {
        if emojiDictionary[card.identifier] == nil, emojiArray.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiArray.count)))
            emojiDictionary[card.identifier] = emojiArray.remove(at: randomIndex)
        }
        return emojiDictionary[card.identifier] ?? "?"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        setCardsTheme()
        emojiArray = game.setTheme(from: emojiThemes)
    }


}

