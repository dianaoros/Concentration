//
//  ViewController.swift
//  Concentration
//
//  Created by Diana Oros on 7/7/20.
//  Copyright © 2020 Diana Oros. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var game = ConcentrationGameModel(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
            return (cardButtons.count + 1) / 2
    }
    private var emojiArray = [String]()
    private var emojiDictionary = [Card: String]()
    private var emojiThemes : [String: [String]] =
        [
        "Holloween": ["🎃", "👻", "💀", "🍎", "🍭", "🍬", "🦇", "😈", "🙀", "🤡"],
        "Sports": ["⚽️", "🏀", "🏈", "🎾", "⚾️", "🛹", "⛸", "🥊", "🎿", "🏓"],
        "Players": ["🏂", "🏋🏽‍♀️", "🤼‍♀️", "🤺", "🤸🏿‍♂️", "🤾🏼‍♀️", "🏄🏻‍♂️", "🧗🏾‍♀️", "🚴🏼", "🏊🏾‍♀️"],
        "Animals": ["🐶", "🐱", "🐯", "🦈", "🐬", "🦧", "🦒", "🐿", "🦜", "🕊"],
        "Fruits": ["🍓", "🍏", "🍇", "🍍", "🍌", "🍉", "🍋", "🍒", "🥥", "🥝"],
        "Veggies": ["🥦", "🥬", "🥕", "🥑", "🍆", "🌽", "🧄", "🥔", "🥒", "🌶"],
        "Moon Phases": ["🌝", "🌛", "🌜", "🌚", "🌕", "🌖", "🌗", "🌘", "🌑", "🌒"]
        ]
    
    @IBOutlet private weak var flipsLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
        else {
            print("Chosen Card was not in cardButtons array")
        }
        
    }
    
    @IBAction private func startNewGame(_ sender: Any) {
        emojiArray = []
        emojiDictionary = [:]
        game.startNewGame()
        emojiArray = game.setTheme(from: emojiThemes)
        updateViewFromModel()
    }
    
    func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.yellow,
            .strokeWidth: -5.0
        ]
        let attributedText = NSAttributedString(string: "Flips: \(game.totalFlipsCount)", attributes: attributes)
        flipsLabel.attributedText = attributedText
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.isEnabled = true
            let card = game.cards[index]
            changeUIColorsBasedOnTheme(with: button, for: card)
            if card.isFaceUp {
                print(card)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                button.setTitle(getEmoji(for: card), for: .normal)
            }
            else {
                button.setTitle("", for: .normal)
                if button.backgroundColor == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) {
                    button.isEnabled = false
                }
            }
        }
        scoreLabel.text = "Score: \(game.score)"
        updateFlipCountLabel()
    }
    
    private func getEmoji(for card: Card) -> String {
        if emojiDictionary[card] == nil, emojiArray.count > 0 {
            emojiDictionary[card] = emojiArray.remove(at: emojiArray.count.arc4random)
        }
        return emojiDictionary[card] ?? "?"
    }
    
    private func changeUIColorsBasedOnTheme(with button: UIButton, for card: Card) {
        switch game.valueInArray {
        case "Holloween":
            view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        case "Sports":
            view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case "Players":
            view.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        case "Animals":
            view.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
            button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        case "Fruits":
            view.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        case "Veggies":
            view.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case "Moon Phases":
            view.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.8705882353, blue: 0, alpha: 1)
        default:
            view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        emojiArray = game.setTheme(from: emojiThemes)
        updateViewFromModel()
    }


}


