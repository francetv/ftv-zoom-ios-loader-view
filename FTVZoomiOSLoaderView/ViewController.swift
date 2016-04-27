//
//  ViewController.swift
//  FTVZoomiOSLoaderView
//
//  Created by William Archimède on 27/04/2016.
//  Copyright © 2016 William Archimède. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let loader = LoaderView()
        loader.layer.foreground

        let constraints = [
            NSLayoutConstraint(item: loader, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
                toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: loader.frame.width),
            NSLayoutConstraint(item: loader, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: loader.frame.height),
            NSLayoutConstraint(item: loader, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loader, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)]

        view.addSubview(loader)
        view.addConstraints(constraints)
        view.setNeedsLayout()

        loader.startAnimation()
    }
}

