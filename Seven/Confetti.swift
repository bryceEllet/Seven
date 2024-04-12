//
//  Confetti.swift
//  Seven
//
//  Created by there#2 on 3/14/24.
//

import UIKit

class Confetti: UIView {

    var spawner: CAEmitterLayer!
    var imageNames = ["confetti", "diamond", "star", "oval", "triangle"]
    var colors: [UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.cyan, UIColor.black, UIColor.purple, UIColor.brown, UIColor.gray]
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func stopConfetti() {
        spawner.birthRate = 0
    }
    
    func startConfetti() {
        spawner = CAEmitterLayer()
        spawner.emitterPosition = CGPoint(x: frame.width/2.0, y: -20.0)
        spawner.emitterShape = .line
        spawner.emitterSize = CGSize(width: frame.width, height: 1.0)
        var cells = [CAEmitterCell]()
        var count = 0
        while count < 20 {
            let imageNumber = Int.random(in: 0...4)
            let colorNumber = Int.random(in: 0...7)
            cells.append(makeConfetti(color: colors[colorNumber], image: UIImage(named: imageNames[imageNumber])!))
            count += 1
        }
        spawner.emitterCells = cells
        layer.addSublayer(spawner)
    }
    
    func makeConfetti(color: UIColor, image: UIImage) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.birthRate = 4.0
        confetti.lifetime = 10.0
        confetti.lifetimeRange = 0.42
        confetti.color = color.cgColor
        confetti.velocity = 200
        confetti.velocityRange = 20
        confetti.emissionLongitude = CGFloat.pi
        confetti.emissionRange = CGFloat.pi
        confetti.spin = 0.42
        confetti.spinRange = 0.42
        confetti.scaleRange = 0.42
        confetti.scaleSpeed = -0.042
        confetti.contents = image.cgImage
        return confetti
    }
    
}
