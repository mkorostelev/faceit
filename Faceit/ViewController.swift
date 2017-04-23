//
//  ViewController.swift
//  Faceit
//
//  Created by Admin on 06/04/2017.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var faceView: FaceView!{
        didSet {
            updateUI()
        }
    }
    
    var expression = FacialExpression(eyes: .closed, mouth: .frown){
        didSet {
            updateUI()
        }
    }
    
    private func updateUI()
    {
        faceView?.eyesOpen = expression.eyes == .open
        
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }
    
    private let mouthCurvatures = [FacialExpression.Mouth.grin: 0.5, .frown: -1.0, .smile: 1.0, .neutral:0.0, .smirk:-0.5]
}

