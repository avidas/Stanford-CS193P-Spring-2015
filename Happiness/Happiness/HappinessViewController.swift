//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Das, Ananya on 2/16/15.
//  Copyright (c) 2015 Das, Ananya. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {
    @IBOutlet weak var faceView: FaceView! {

        //property observer
        didSet {
            faceView.dataSource = self
            //action needs to be non private method in faceview so can be handled
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
        }
    }
    
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            //tells change in faceViews coordinate system
            let translation = gesture.translationInView(faceView)
            let happinessChange = -Int(translation.y  / Constants.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
        default: break
        }
    }
    private struct Constants {
        //Every four points we move, change happiness by 1
        static let HappinessGestureScale: CGFloat = 4
    }

    //Controllers interprets the model for the view
    var happiness: Int = 100 { // 0 = very sad, 100 ecstatic
        didSet {
            happiness = min(max(happiness, 0), 100)
            println("happiness = \(happiness)")
            updateUI()
        }
    }
    
    private func updateUI()
    {
        //when happiness change faceview redraw
        faceView.setNeedsDisplay()
    }
    
    // translate happiness to smiliness
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness-50)/50
    }
    

}
