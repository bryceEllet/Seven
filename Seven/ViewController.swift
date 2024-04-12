//
//  ViewController.swift
//  Seven
//
//  Created by there#2 on 2/29/24.
//

import UIKit

enum Saved {
    static let level = "com.jonesclass.ellet.seven.level"
    static let score = "com.jonesclass.ellet.seven.score"
}

class ViewController: UIViewController {
    var confettiSpawner: Confetti!
    var saveGame = UserDefaults.standard
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var totalLevels = 1
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 12 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var guessTextField: UITextField!
    @IBAction func submitPressed(_ sender: UIButton) {
        submitGuess()
    }
    @IBAction func clearPressed(_ sender: UIButton) {
        guessTextField.text = ""
        for button in activatedButtons {
            button.isEnabled = true
        }
        activatedButtons.removeAll()
//        self.view.addSubview(confettiSpawner)
//        confettiSpawner.startConfetti()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findSubviews(view: view)
        countLevels()
        if let currentLevel = saveGame.string(forKey: Saved.level) {
            level = Int(currentLevel)!
            score = Int(saveGame.string(forKey: Saved.score)!)!
        }
        confettiSpawner = Confetti(frame: self.view.bounds)
        loadLevel()
    }
    
    func findSubviews(view: UIView) {
        if view.tag == 1001 {
            let button = view as! UIButton
            letterButtons.append(button)
            button.addTarget(self, action: #selector(lettersTapped), for: .touchUpInside)
        } else {
            for subview in view.subviews {
                findSubviews(view: subview)
            }
        }
    }
    
    func submitGuess() {
        if let solutionIndex = solutions.firstIndex(of: guessTextField.text!) {
            var answerArray = answersLabel.text!.components(separatedBy: "\n")
            answerArray[solutionIndex] = guessTextField.text!
            answersLabel.text = answerArray.joined(separator: "\n")
            guessTextField.text = ""
            score += 1
            activatedButtons.removeAll()
            checkForWinner()
        } else {
            //wrong
        }
    }
    
    func checkForWinner() {
        if score % 7 == 0 {
            self.view.addSubview(confettiSpawner)
            confettiSpawner.startConfetti()
            var title = "Next Level"
            var message = "You have completed the level!"
            if level >= totalLevels {
                title = "Play Again"
                message = "You have completed the game!"
            }
            let ac = UIAlertController(title: "Congratulations!", message: message, preferredStyle: .alert)
            let newGameAction = UIAlertAction(title: title, style: .default) {
                _ in self.levelUp()
            }
            ac.addAction(newGameAction)
            present(ac, animated: true)
        }
    }
    
    func levelUp() {
        confettiSpawner.stopConfetti()
        confettiSpawner.removeFromSuperview()
        if level >= totalLevels {
            level = 0
            score = 0
        }
        level += 1
        saveGame.set("\(level)", forKey: Saved.level)
        saveGame.set("\(score)", forKey: Saved.score)
        solutions.removeAll()
        for button in letterButtons {
            button.isEnabled = true
        }
        loadLevel()
    }
    
    @objc func lettersTapped(button: UIButton) {
        activatedButtons.append(button)
        button.isEnabled = false
        guessTextField.text = guessTextField.text! + button.currentTitle!
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFilePath = Bundle.main.path(forResource: "level\(level)", ofType: "txt") {
            if let levelContents = try? String(contentsOfFile: levelFilePath) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    clueString += "\(index + 1). \(clue)\n"
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutions.append(solutionWord)
                    solutionString += "\(solutionWord.count) letters\n"
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        } else {
            // no file of that level
        }
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        if letterBits.count == letterButtons.count {
            for index in 0..<letterButtons.count {
                letterButtons[index].setTitle(letterBits[index], for: .normal)
            }
        }
    }
    
    func countLevels() {
        var counter = 1
        while Bundle.main.path(forResource: "level\(counter)", ofType: ".txt") != nil {
            counter += 1
        }
        totalLevels = counter - 1
    }
}

/*
 TR|UNK: Where you put a body!
 FR|ID|GE: Where you put an elephant!
 PA|ND|A: Express!
 AR|BYS: Meat Mountain!
 MO|OO|VE: What a cow says!
 BLA|CKJ|ACK: Place your bets!
 PU|ZZ|LI|NG: This clue.
 */
