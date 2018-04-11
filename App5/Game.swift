//
//  Game.swift
//  App5
//
//  Created by Charles Astor on 11/16/17.
//  Copyright © 2017 Charles Astor. All rights reserved.
//

import UIKit
import AVFoundation

class Game: UIView {
    
    
    
    @IBOutlet weak var score: UILabel!
    
    @IBOutlet weak var shotsF: UILabel!
    @IBOutlet weak var cannonball: UIImageView!
    @IBOutlet weak var pic1: UIImageView!
    private var objects = [UIImageView()]
    private var cannon_x : CGFloat = 0.0
    private var cannon_y : CGFloat = 0.0
    private var img1 : UIImage!
    private var img2 : UIImage!
    private var shots = 0
    private var scoreNum = 0
    public var cannonBallView: UIImageView!
    private var timer : Timer!
    private var screenSize = UIScreen.main.bounds
    private var startOver: CGRect!
    private var rectangleHeight = Int(0.125 * UIScreen.main.bounds.height)
    private var inPlay = false
    private var isHIt = false
    private var  start_time = 0.0
    private var  end_time = 0.0
    private let PIX_M = 10
    private var alph: CGFloat = 0.0
    private var velocityX: CGFloat = 0.0
    private var velocityY: CGFloat = 0.0
    private var initialX: CGFloat =  0.0
    private var initialY: CGFloat =  0.0
    private var velocity: CGFloat = 0.0
    private var t = 0.0
    private var t2 = 0.0
    private var dirX = 1
    private var dirY = 1
    private var player : AVPlayer!
    private var yY:CGFloat = 0.0
    private var xX:CGFloat = 0.0
    private var  start_point : CGPoint!
    private var  end_point : CGPoint!
    
    
    
    
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder)
    {
        //Code goes here
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        
        restart()
        
    }
    
    func restart() {
        
        // self.backgroundColor = UIColor.blue
        
        scoreNum = 0
        shots = 0
        score.text = "\(scoreNum)"
        shotsF.text = "\(shots)"
        let img = UIImage(named: "bg2.png")
        self.backgroundColor = UIColor(patternImage: img!)
        
        
        //Add all the targets
        
        var x1 : Int = 0
        var y1 : Int = 0
        
        let width = self.bounds.width
        let height = self.bounds.height
        
        
        
        //Add all the targets
        for _ in 0..<10
        {
            
            
            x1 = Int(arc4random()) % Int(Double(width * 0.8))
            y1 = Int(arc4random()) % Int(Double((height/2) * 0.9)) + 30
            
            
            //Create UIImageView
            let view = UIImageView(frame: CGRect(x: CGFloat(x1), y: CGFloat(y1), width: pic1.frame.size.width, height: pic1.frame.size.height))
            
            
            
            view.image = UIImage(named: "touched")
            view.isHidden = false
            
            //Add to array
            
            objects.append(view)
            
            //Add the image to the view
            self.addSubview(view)
            
            
            
            
            
        }
        //Create frame, add view
        let screenSize = UIScreen.main.bounds
        
        
        cannon_x  = ((screenSize.width - 10)/2) - 10
        cannon_y  = screenSize.height - CGFloat(rectangleHeight)
        
        initialX = ((screenSize.width - 10)/2) - 10
        
        initialY = screenSize.height - CGFloat(rectangleHeight)
        cannonBallView = UIImageView(frame: CGRect(x: cannon_x, y: cannon_y, width: pic1.frame.size.width, height: pic1.frame.size.height))
        
        
        
        
        
        cannonBallView.image = UIImage(named: "cannonBall1.png")
        self.addSubview(cannonBallView)
        cannonBallView.isHidden = false
        self.setNeedsDisplay()
        
        self.startOver = cannonBallView.frame
        
        
        
        
    }
    
    
    func playSound() {
        if let path = Bundle.main.path(forResource: "target_hit", ofType: "wav")  {
            let url = URL(fileURLWithPath: path)
            player = AVPlayer(url: url)
            
            player.play()
            
        } else {
            print("no sound file")
        }
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Draw cannonballview
        cannonBallView.frame =  CGRect(x:  cannon_x, y: cannon_y , width: cannonBallView.frame.size.width, height: cannonBallView.frame.size.height)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        
        let screenSize = UIScreen.main.bounds
        
        
        
        
        // Draw Pole
        ctx?.setFillColor(red: 0.83, green: 0.5, blue: 0.1, alpha: 1);
        ctx?.fill(CGRect(x: (screenSize.width-10)/2, y: screenSize.height-50, width: 20, height: CGFloat(rectangleHeight)));
        
        ctx?.drawPath(using: CGPathDrawingMode.fillStroke)
        
        //Draw Ground
        ctx?.setFillColor(red: 1, green: 1, blue: 0.45, alpha: 1)
        ctx?.fill(CGRect(x: 0, y: screenSize.height-10, width: screenSize.width, height: 10))
        
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var all_touches = Array(touches)
        
        let start_touch = all_touches[0]
        
        //Get the location
        start_point = start_touch.location(in: self)
        
        //Get the time
        start_time = start_touch.timestamp
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var all_touches = Array(touches)
        
        let end_touch = all_touches[0]
        
        //Get the location
        end_point = end_touch.location(in: self)
        
        //Get the time
        end_time = end_touch.timestamp;
        
        
        
        let dist = Double(sqrt(pow(end_point.x - start_point.x,2.0)+pow(end_point.y - start_point.y,2.0)));
        let delta_t = end_time - start_time;
        velocity = CGFloat(dist/delta_t);
        
        
        
        let lenY = (Double(end_point.y) - Double(start_point.y))/Double(dist)
        let lenX = (Double(end_point.x) - Double(start_point.x))/Double(dist)
        velocityX = CGFloat(velocity * CGFloat(lenX))
        velocityY = CGFloat(velocity * CGFloat(lenY))
        
        if(inPlay == false) {
            
            let touchPoint = end_touch.location(in: self)
            
            if(touchPoint.x > cannonBallView.frame.origin.x) && (touchPoint.x < cannonBallView.frame.origin.x + 40) &&
                (touchPoint.y > cannonBallView.frame.origin.y) && (touchPoint.y < (cannonBallView.frame.origin.y + 40)) {
                print("this run")
                timer = Timer.scheduledTimer(timeInterval: 0.025, target: self, selector:#selector(Game.timerFired), userInfo: self, repeats: true)
                inPlay = true
                shots += 1
                shotsF.text = "\(shots)"
            }
            
        }
        
        
    }
    
    
    
    func removeRed() {
        for (_,obj) in objects.enumerated() {
            if(obj.image == UIImage(named: "untouched")) {
                obj.isHidden = true
                
                
            }
        }
    }
    
    
    
    func timerFired()
    {
        
        for obj in objects
        {
            
            if cannonBallView.frame.intersects(obj.frame) {
                // isHIt = true
                
                let tmpImg = obj.image
                obj.image  = UIImage(named: "untouched.png")!
                if(tmpImg != obj.image && obj.image != nil) {
                    if(scoreNum < 10) {
                        scoreNum += 1
                    }
                    score.text = "\(scoreNum)"
                    playSound()
                    
                    
                }
                
                
            }
        }
        
        
        
        
        t += 0.025
        t2 += 0.025
        
        if(velocityX > 0 && cannon_x > self.bounds.maxX) {
            dirX -= 1
            
        }
        else if (velocityY > 0 && cannon_x < 0) {
            dirX += 1
            
        }
        if(velocityX < 0 && cannon_x < 0) {
            dirX = -1
        }
        else if (velocity < 0 && cannon_x > self.bounds.width) {
            dirX = 1
        }
        
        if (cannon_y < 0) {
            dirY = -1
            velocity = velocityY + CGFloat(9.8) * CGFloat(t)
        }
        
        if(dirY == -1) {
            cannon_x += CGFloat(Double(dirX) * Double(velocityX) * 0.025 * Double(PIX_M))
            t = 0
            t2 = t + 0.025
            
            let a  = CGFloat(dirY) * CGFloat(velocity) * 0.025 + 0.025 + 0.5 + 9.8
            let b = CGFloat(t2) + CGFloat(t)  * 0.25 * CGFloat(PIX_M)
            
            cannon_y += (a * b)
        } else {
            cannon_x += CGFloat(CGFloat(dirX) * CGFloat(velocityX) * 0.025 * CGFloat(PIX_M))
            cannon_y += CGFloat((CGFloat(dirY) * CGFloat(velocityY) * 0.025 + 0.5 * 9.8 * (CGFloat(t2) + CGFloat(t)) * 0.25) * CGFloat(PIX_M))
        }
        
        self.setNeedsDisplay()
        
        
        
        let re = allHidden()
        if(re) {
            cannonBallView.isHidden = true
            let alert = UIAlertController(title: "Awesome", message: "The game is over!", preferredStyle: .alert)
            
            let restartAction = UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) in  self.restart() })
            
            alert.addAction(restartAction)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }
        
        if(cannonBallView.frame.origin.x + 20  < 0 || cannonBallView.frame.origin.x
            > 500 ||  cannonBallView.frame.origin.y   < 0 || cannonBallView.frame.origin.y   >  1000 ){
            print(cannonBallView.frame.origin)
            inPlay = false
            cannon_x = initialX
            cannon_y = initialY
            removeRed()
            
            dirX = 1
            dirY = 1
            t = 0
            t2 = 0.025
            timer.invalidate()
            
            
            
        }
        
        
        self.setNeedsDisplay()
        return
        
        
    }
    
    func allHidden() -> Bool {
        var hidden = true
        for obj in objects {
            if(obj.image == UIImage(named: "touched" )) {
                hidden = false
                return hidden
            }
            
        }
        return hidden
        
    }
    
}









