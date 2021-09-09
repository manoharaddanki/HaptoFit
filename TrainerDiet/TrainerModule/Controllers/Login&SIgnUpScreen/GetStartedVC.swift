//
//  GetStartedVC.swift
//  MoviesMagic
//
//  Created by laxman on 7/17/19.
//  Copyright © 2019 Rize. All rights reserved.
//

import UIKit

class GetStartedVC: UIViewController {

    @IBOutlet var mainSlideImageView: UIImageView!
    
    @IBOutlet var dotsImageView: UIImageView!

    @IBOutlet var slidingView: UIView!

    @IBOutlet var middleImageV: UIImageView!
    
    @IBOutlet var descLbl: UILabel!
    
    @IBOutlet var descTitleLbl: UILabel!
    
    @IBOutlet var letDoThisBtn: UIButton!
    
    var currentImage = 0
    
    let imageNames = ["icare","ipersonalise","itrack"]
    
    let dotsimageNames = ["dot1","dot2","dot3"]
    
    let descNames = ["Created by Scientists, Nutritionists & Engineers","Get instant personslised Meal Plans","We do Tracking while you do scoring"]
    
    let descTitleNames = ["India's First AI Based Diet Bot","Tailored Diet Plans","Track your wellness progress"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.slidingView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.slidingView.addGestureRecognizer(swipeLeft)
        // Do any additional setup after loading the view, typically from a nib.
        
        letDoThisBtn.setTitle("Skip", for: .normal)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizer.Direction.left:
                if currentImage == imageNames.count - 1 {
                   
                    // currentImage = 0
                    return
                    
                }else{
                    
                    if currentImage < imageNames.count - 2 {
                        
                        letDoThisBtn.setTitle("Skip", for: .normal)
                        
                    } else {
                        
                        letDoThisBtn.setTitle("Done", for: .normal)
                    }
                    
                    currentImage += 1
                }

                let animation = CATransition()
                animation.duration = 0.5;
                animation.type = CATransitionType.moveIn;
                animation.subtype = CATransitionSubtype.fromRight;
                slidingView.layer.add(animation, forKey: "imageTransition")
                middleImageV.image = UIImage(named: imageNames[currentImage])
                descLbl.text = descNames[currentImage]
                descTitleLbl.text = descTitleNames[currentImage]
            
                UIView.transition(with: dotsImageView,
                                  duration: 0.75,
                                  options: .transitionCrossDissolve,
                                  animations: { self.dotsImageView.image = UIImage(named: self.dotsimageNames[self.currentImage])},
                                  completion: nil)

            case UISwipeGestureRecognizer.Direction.right:
                
                if currentImage == 0 {
                   
                    //currentImage = imageNames.count - 1
                    return
                }else{
                    currentImage -= 1
                }
                
                letDoThisBtn.setTitle("Skip", for: .normal)

                let animation = CATransition()
                animation.duration = 0.5;
                animation.type = CATransitionType.moveIn;
                animation.subtype = CATransitionSubtype.fromLeft;
                slidingView.layer.add(animation, forKey: "imageTransition")
                middleImageV.image = UIImage(named: imageNames[currentImage])
                descLbl.text = descNames[currentImage]
                descTitleLbl.text = descTitleNames[currentImage]

                UIView.transition(with: dotsImageView,
                                  duration: 0.75,
                                  options: .transitionCrossDissolve,
                                  animations: { self.dotsImageView.image = UIImage(named: self.dotsimageNames[self.currentImage])},
                                  completion: nil)
                

            default:
                break
            }
        }
    }

    @IBAction func letsDoThisBtnAction(_ sender: Any) {
        
        if currentImage == imageNames.count - 1 {
            
            let objVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            
            self.navigationController?.pushViewController(objVC, animated: true)
        }
        else{
            
            let objVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            
            self.navigationController?.pushViewController(objVC, animated: true)
        }
        
    }
}
