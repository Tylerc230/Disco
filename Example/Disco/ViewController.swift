//
//  ViewController.swift
//  Disco
//
//  Created by Tyler Casselman on 09/13/2018.
//  Copyright (c) 2018 Tyler Casselman. All rights reserved.
//

import UIKit
import Disco

class ViewController: UIViewController {
    @IBOutlet var animatedView: UIView!
    @IBOutlet var slider: UISlider!
    var animation: AnimationRunner?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animation = animatedView.disco
            .moveCenter(to: CGPoint(x: 20.0, y: 2.0))
            .setBackgroundColor(to: .red)
            .duration(5.0)
            .then()
            .setBackgroundColor(to: .blue)
            .addCompletion { (position) in
                print("HERE")
            }
            .start()
    }
    
    @IBAction
    func sliderDidChange() {
        animation?.setFractionComplete(CGFloat(slider.value))
    }

}

