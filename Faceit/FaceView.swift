import UIKit
@IBDesignable
class FaceView: UIView
{
    // Public API
    @IBInspectable
    var mouthCurvature: Double = 0.5 // 1.0 is full smile and -1.0 is full frown
    @IBInspectable
    var eyesOpen: Bool = true
    @IBInspectable
    var scale: CGFloat = 0.9
    @IBInspectable
    var lineWidth: CGFloat = 5.0
    @IBInspectable
    var color: UIColor = UIColor.blue
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer){
        switch pinchRecognizer.state {
        case .changed, .ended:
            scale *= pinchRecognizer.scale
            
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    // Private Implementation
    private struct Ratios {
        static let skullRadiusToEyeOffset: CGFloat = 3
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToMouthWidth: CGFloat = 1
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 3
    }
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private enum Eye {
        case left
        case right }
    private func pathForEye(_ eye: Eye) -> UIBezierPath
    {
        func centerOfEye(_ eye: Eye) -> CGPoint {
            let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
            var eyeCenter = skullCenter
            eyeCenter.y -= eyeOffset
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
            return eyeCenter
        }
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)
        let path: UIBezierPath
        if eyesOpen {
            path = UIBezierPath(
                arcCenter: eyeCenter,
                radius: eyeRadius,
                startAngle: 0,
                endAngle: CGFloat.pi * 2,
                clockwise: true
            )
        } else {
            path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        }
        path.lineWidth = lineWidth
        return path }
    private func pathForMouth() -> UIBezierPath
    {
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
        let mouthRect = CGRect(
            x: skullCenter.x - mouthWidth / 2,
            y: skullCenter.y + mouthOffset,
            width: mouthWidth,
            height: mouthHeight
        )
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        let cp1 = CGPoint(x: start.x + mouthRect.width / 3, y: start.y + smileOffset)
        let cp2 = CGPoint(x: end.x - mouthRect.width / 3, y: start.y + smileOffset)
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }

    private func pathForSkull() -> UIBezierPath {
        let path = UIBezierPath(
            arcCenter: skullCenter,
            radius: skullRadius,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: false
        )
        path.lineWidth = lineWidth
        return path
    }
    override func draw(_ rect: CGRect) {
        color.set()
        pathForSkull().stroke()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()
    } }



////
////  FaceView.swift
////  Faceit
////
////  Created by Admin on 06/04/2017.
////  Copyright © 2017 home. All rights reserved.
////
//
//import UIKit
//
//@IBDesignable
//class FaceView: UIView {
//    @IBInspectable
//    let scale:CGFloat = 0.9
//    
//    @IBInspectable
//    let endAngle:CGFloat = 2 * CGFloat.pi
//    
//    @IBInspectable
//    let startAngleCloseEye:CGFloat = CGFloat.pi
//    
//    @IBInspectable
//    let lineWidth:CGFloat = 5.0
//    
//    @IBInspectable
//    var eyesOpen:Bool = false
//    
//    @IBInspectable
//    var mouthCurvature:Double = 1.0 // 1.0 is full smile and -1.0 is full frown
//    
//    @IBInspectable
//    let color:UIColor = UIColor.blue
//    
////    var mouthCurvatureStep = -0.1
//    
//    private var skullRadius:CGFloat{
//        return min(bounds.size.width, bounds.size.height) / 2 * scale
//    }
//    
//    private var skullCenter:CGPoint{
//        return CGPoint(x: bounds.midX, y: bounds.midY)
//    }
//    
//    private enum Eye {
//        case left
//        case right
//        
//    }
//    
//    private func pathForEye(_ eye: Eye) -> UIBezierPath {
//        func centerOfEye(_ eye:Eye) -> CGPoint {
//            let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
//            
//            var eyeCenter = skullCenter
//            
//            eyeCenter.y -= eyeOffset
//            
//            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
//            
//            return eyeCenter
//        }
//        
//        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
//        
//        let eyeCenter = centerOfEye(eye)
//        
//        var startAngle:CGFloat = 0
//        
//        if !eyesOpen{
//            startAngle = startAngleCloseEye
//        }
//        
//        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//        
//        path.lineWidth = lineWidth
//        
//        return path
//            
//    }
//    
//    private func pathForMouth() -> UIBezierPath {
//        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
//        
//        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
//        
//        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
//        
//        let mouthRect = CGRect(
//            x: skullCenter.x - mouthWidth / 2,
//            y: skullCenter.y + mouthOffset,
//            width: mouthWidth,
//            height: mouthHeight
//        )
//        
//        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
//        
//        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
//        
//        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
//        
//        let cp1 = CGPoint(x: start.x + mouthRect.width / 3, y: start.y + smileOffset)
//        
//        let cp2 = CGPoint(x: end.x - mouthRect.width / 3, y: start.y + smileOffset)
//        
//        let path = UIBezierPath()
//        
//        path.lineWidth = lineWidth
//        
//        path.move(to: start)
//        
//        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
//        return path
//    }
//    
//    private func pathForSkull() -> UIBezierPath {
//        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: endAngle, clockwise: false)
//        
//        path.lineWidth = lineWidth
//        
//        return path
//    }
//    
//    override func draw(_ rect: CGRect) {
//        color.set()
//        
//        pathForSkull().stroke()
//        
//        pathForEye(.left).stroke()
//        
//        pathForEye(.right).stroke()
//        
//        pathForMouth().stroke()
//        
////        eyesOpen = !eyesOpen
//        
////        if mouthCurvature >= 1 {
////           mouthCurvatureStep = -0.1
////        }
////        else if mouthCurvature <= -1 {
////           mouthCurvatureStep = 0.1
////        }
////        
////        mouthCurvature += mouthCurvatureStep
//    
//    }
//    
//    private struct Ratios {
//        static let skullRadiusToEyeOffset: CGFloat = 3
//        
//        static let skullRadiusToEyeRadius: CGFloat = 10
//        
//        static let skullRadiusToMouthWidth: CGFloat = 1
//        
//        static let skullRadiusToMouthHeight: CGFloat = 3
//        
//        static let skullRadiusToMouthOffset: CGFloat = 3
//    }
//}
