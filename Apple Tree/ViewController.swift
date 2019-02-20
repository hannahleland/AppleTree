//
//  ViewController.swift
//  Apple Tree
//
//  Created by student5 on 2/17/19.
//  Copyright © 2019 Hannah Leland. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var words = ["pillowcase","toaster","diffusion","socks","bookmark","comforter","headphones","snowflake","hungry","monday","gluestick","toe","belly","interobang","cold","programmer"]

    let incorrectMovesAllowed = 7
    var totalWins = 0 {
        didSet {
            newRound()
        }
    }
    var totalLosses = 0 {
        didSet {
            newRound()
        }
    }
    var currentGame = Game(word: "", incorrectMovesRemaining: 0, guessedLetters: [])
    
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        newRound()
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    } // end buttonPressed
    
    
    func newRound() {
        if !words.isEmpty {
            let index = Int.random(in: 0 ... (words.count - 1))
            let newWord = words.remove(at: index)
            currentGame = Game(word: newWord,
                               incorrectMovesRemaining: incorrectMovesAllowed,
                               guessedLetters: [])
            enableLetterButtons(true)
            updateUI()
        } else {
            enableLetterButtons(false)
        }
    } // end newRound
    
    
    func updateUI() {
        var letters = [String]()
        for letter in currentGame.formattedWord.characters {
            letters.append(String(letter))
        }
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
        scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
        } // end updateUI
    
    func updateGameState() {
        if currentGame.incorrectMovesRemaining == 0 {
            let alert = UIAlertController(title: "Uh oh 😔", message: "\nCorrect word: \(currentGame.word)\n\nYou lose this round", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: {_ in alert.dismiss(animated: true, completion: nil)})
            totalLosses += 1
        } else if currentGame.word == currentGame.formattedWord {
            let alert = UIAlertController(title: "Yay 🥳", message: "\nCorrect word: \(currentGame.word)\n\nYou win this round", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: {_ in alert.dismiss(animated: true, completion: nil)})
            totalWins += 1
        } else {
            updateUI()
        }
    }
    
    func enableLetterButtons(_ enable: Bool) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
} // end ViewController

struct Game {
    var word : String
    var incorrectMovesRemaining : Int
    var guessedLetters: [Character]
    
    mutating func playerGuessed(letter: Character) {
        guessedLetters.append(letter)
        if !word.contains(letter) {
            incorrectMovesRemaining -= 1
        }
    }
    
    var formattedWord: String {
        var guessedWord = ""
        for letter in word.characters {
            if guessedLetters.contains(letter) {
                guessedWord += "\(letter)"
            } else {
                guessedWord += "_"
            }
        }
        return guessedWord
    }
    
} // end Game
