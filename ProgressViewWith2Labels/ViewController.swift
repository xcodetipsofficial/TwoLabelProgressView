//
//  ViewController.swift
//  ProgressViewWith2Labels
//
//  Created by Kyle Wilson on 2022-05-03.
//

import UIKit

class ViewController: UIViewController {
    
    let myProgressView = MyProgressView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        myProgressView.center = view.center //center the view
        myProgressView.layer.borderColor = UIColor.white.cgColor
        myProgressView.layer.borderWidth = 3
        myProgressView.layer.cornerRadius = myProgressView.frame.height / 2 //add corner radius for rounding the view
        myProgressView.clipsToBounds = true //clip the progress to the rounded view
        myProgressView.progressColor = .red
        myProgressView.progressMax = 1 //second progress or max progress, 1 means $100 in this case
        view.addSubview(myProgressView)
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(addProgress), userInfo: nil, repeats: true) //fire timer every 0.5 seconds
    }
    
    @objc func addProgress() {
        if myProgressView.progress < 1 { //1 is $100
            myProgressView.progress += 0.05 //add $5 until reach limit
        } else {
            print("reached limit!")
            timer.invalidate() //turn off timer
        }
    }

}

class MyProgressView: UIView {
    
    var progressColor = UIColor(red: 108/255, green: 200/255, blue: 226/255, alpha: 1) //default progress color

    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay() //redraws the view when value changes
        }
    }
    
    var progressMax: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        //Setup vairables for getting progress for drawing
        let size = bounds.size
        let foregroundColor = UIColor.white
        let font = UIFont.boldSystemFont(ofSize: 25)

        let progress = NSString(format: "$%d", Int(round(self.progress * 100)))
        var attributes: [NSAttributedString.Key: Any] = [.font: font]
        let textSize = progress.size(withAttributes: attributes)
        let progressX = ceil(self.progress * size.width)
        let textPoint = CGPoint(x: 10, y: ceil((size.height - textSize.height) / 2))
        
        let secondProgress = NSString(format: "$%d", Int(round(self.progressMax * 100)))
        let secondTextSize = secondProgress.size(withAttributes: attributes)
        let secondTextPoint = CGPoint(x: (self.bounds.width - secondTextSize.width) - 10, y: ceil((size.height - secondTextSize.height) / 2))

        //Background + foreground text
        progressColor.setFill()
        context?.fill(bounds)
        attributes[.foregroundColor] = foregroundColor
        progress.draw(at: textPoint, withAttributes: attributes)
        secondProgress.draw(at: secondTextPoint, withAttributes: attributes)

        //Clip the drawing that follows to the remaining progress's frame
        context?.saveGState()
        let remainingProgressRect = CGRect(x: progressX, y: 0, width: size.width - progressX, height: size.height)
        context?.addRect(remainingProgressRect)
        context?.clip()

        //Draw again with inverted colors
        foregroundColor.setFill()
        context?.fill(bounds)
        attributes[.foregroundColor] = progressColor
        progress.draw(at: textPoint, withAttributes: attributes)
        secondProgress.draw(at: secondTextPoint, withAttributes: attributes)

        context?.restoreGState()
    }
}
