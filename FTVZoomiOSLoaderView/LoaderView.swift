//
//  LoaderView.swift
//  FTVZoomiOSLoaderView
//
//  Created by William Archimède on 27/04/2016.
//  Copyright © 2016 William Archimède. All rights reserved.
//

import UIKit

class LoaderView: UIView {

    private static let loaderWidth = CGFloat(128)
    private static let loaderHeight = CGFloat(68)

    let startupDuration = 1.0 as NSTimeInterval     // In seconds
    let animationDuration = 1.0 as NSTimeInterval   // In seconds
    let pauseDuration = 0.1 as NSTimeInterval       // In seconds

    private var phase = 0
    private var maskingLayer: CALayer!
    private var loaderLayer: LoaderLayer!
    private var isStarted = false


    // MARK: - Lifecycle

    convenience init() {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: LoaderView.loaderWidth, height: LoaderView.loaderHeight))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        hidden = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.clearColor()
        opaque = false
        layer.contentsScale = UIScreen.mainScreen().scale
        loaderLayer = LoaderLayer()
        loaderLayer.frame = frame
        layer.addSublayer(loaderLayer)

        let maskingImage = UIImage(named: "LoaderBlack.png")!
        maskingLayer = CALayer()
        maskingLayer.frame = bounds
        maskingLayer.contents = maskingImage.CGImage
        layer.mask = maskingLayer
    }

    // MARK: - Animation

    func startAnimation() {
        loaderLayer.removeAllAnimations()

        isStarted = true
        reset()

        // Initial phase : do a long pause before starting disk animation
        setProgress(0.0, animated: true, duration: startupDuration)
    }

    private func reset() {
        phase = 0
        loaderLayer.inverted = false
        setProgress(0.0, animated: false)
    }

    private var progress: Float {
        get {
            return loaderLayer.progress
        }
        set {
            let growing = newValue > progress
            setProgress(newValue, animated: growing, duration: animationDuration)
        }
    }

    private func setProgress(progress: Float, animated: Bool, duration: NSTimeInterval = 0.0) {
        // Coerce the value
        var newValue = progress
        if newValue < 0.0 {
            newValue = 0.0
        } else if newValue > 1.0 {
            newValue = 1.0
        }

        loaderLayer.removeAllAnimations()
        if animated {
            let animation = CABasicAnimation(keyPath: "progress")
            animation.duration = animationDuration
            animation.fromValue = NSNumber(float: loaderLayer.progress)
            animation.toValue = NSNumber(float: newValue)
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.delegate = self
            loaderLayer.addAnimation(animation, forKey: "progressAnimation")
            loaderLayer.progress = newValue
        } else {
            loaderLayer.progress = newValue
            loaderLayer.setNeedsDisplay()
        }
    }

    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        guard isStarted else {
            return
        }

        switch phase {
        case 0:
            // First phase of the animation : fill the disks with red
            phase = 1
            hidden = false
            setProgress(1.0, animated: true, duration: animationDuration)
        case 1:
            // Second phase of the animation : little pause
            phase = 2
            setProgress(1.0, animated: true, duration: pauseDuration)
        case 2:
            // Third phase of the animation : fill the disks with grey
            phase = 3
            loaderLayer.inverted = true
            setProgress(0.0, animated: false)
            setProgress(1.0, animated: true, duration: animationDuration)
        case 3:
            // Second phase of the animation : little pause
            phase = 4
            setProgress(1.0, animated: true, duration: pauseDuration)
        default:
            // Restart with first phase
            phase = 0
            loaderLayer.inverted = false
            setProgress(0.0, animated: false)
            animationDidStop(anim, finished: flag)
        }
    }
}

class LoaderLayer: CALayer {

    var progress: Float = 0.0
    var inverted = false

    var foregroundColor = UIColor.redColor()
    let backColor = UIColor.darkGrayColor()

    override init() {
        super.init()
    }

    override init(layer: AnyObject) {
        super.init(layer: layer)

        if layer is LoaderLayer {
            let otherLayer = layer as! LoaderLayer
            progress = otherLayer.progress
            inverted = otherLayer.inverted
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override class func needsDisplayForKey(key: String) -> Bool {
        if key == "progress" {
            return true
        } else {
            return super.needsDisplayForKey(key)
        }
    }

    private let diskRatio: CGFloat = 0.86

    override func drawInContext(context: CGContext) {
        let radius = min(bounds.size.width, bounds.size.height)/2.0 * 2
        let center = CGPoint(x: bounds.size.width/2.0, y: bounds.size.height/2.0)

        // Draw background
        let circleRect = CGRect(x: center.x-radius, y: center.y-radius, width: radius*2.0, height: radius*2.0)
        CGContextAddEllipseInRect(context, circleRect)
        if inverted {
            CGContextSetFillColorWithColor(context, foregroundColor.CGColor)
        } else {
            CGContextSetFillColorWithColor(context, backColor.CGColor)
        }
        CGContextFillPath(context)

        // Draw 2 disks based on progress
        drawDisk(context, center: CGPoint(x: center.x + bounds.size.width * 0.2, y: center.y), startAngle: CGFloat(M_PI * 2.0) * (diskRatio - 0.5))
        drawDisk(context, center: CGPoint(x: center.x - bounds.size.width * 0.2, y: center.y), startAngle: CGFloat(M_PI * 2.0) * diskRatio)
    }

    private func drawDisk(context: CGContext!, center: CGPoint, startAngle: CGFloat) {
        let radius = bounds.size.height * 0.57
        let deltaAngle = CGFloat(progress) * 2.0 * CGFloat(M_PI) * diskRatio        // In radians

        CGContextAddArc(context, center.x, center.y, radius, startAngle, startAngle - deltaAngle, 1)      // 1 for clockwise
        CGContextAddLineToPoint(context, center.x, center.y)
        CGContextClosePath(context)
        if inverted {
            CGContextSetFillColorWithColor(context, backColor.CGColor)
        } else {
            CGContextSetFillColorWithColor(context, foregroundColor.CGColor)
        }
        CGContextFillPath(context)
    }
}

