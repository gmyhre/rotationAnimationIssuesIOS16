//
//  ViewController.swift
//  rotationIssues
//
//  Created by Graham Myhre on 10/24/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var BottomView: UIView!
    
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    @IBOutlet weak var bottomViewLeading: NSLayoutConstraint!
    
    var portraitConstraints: [NSLayoutConstraint] = []
    var landscapeConstraints: [NSLayoutConstraint] = []
    
    private var lastSupportedInterfaceOrientation : UIInterfaceOrientation! = .unknown
    // just start the experiement in portrait.
    
    var currentSupportedOrientation : UIInterfaceOrientation {
        let viewOrientation = self.preferredInterfaceOrientationForPresentation
        return viewOrientation
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //
        BottomView.translatesAutoresizingMaskIntoConstraints = false
        
        // pop the interface builder constraints in there:
        portraitConstraints.append(bottomViewHeight)
        portraitConstraints.append(bottomViewTrailing)
        portraitConstraints.append(bottomViewLeading)
        portraitConstraints.append(bottomViewBottom)

        self.lastSupportedInterfaceOrientation = self.currentSupportedOrientation
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


        //#################################################
        //KEY LINE
        // UIView.setAnimationsEnabled(false)
        //  turns off all animations in iOS 15.x and below
        //  iOS 16.x shows animation on rotations
        //#################################################
        
        // set it here for obvious example
        UIView.setAnimationsEnabled(false)  // works for basic animations, but not roations
        

    }
    
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)


    }

    
    
    
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        // redundant
        //UIView.setAnimationsEnabled(false)

        super.viewWillTransition(to: size, with: coordinator)
        print("viewWillTransition called")
        //print("a breakpoint .  Rotation Animation has already started in iOS 16 but not in iOS 15 and below!!!")
        // Put code to be run BEFORE the rotation here...

        
        coordinator.animate(alongsideTransition: nil) { _ in
            // Put code to be run after the rotation,
            // or after frame-size change here...

            // In an ideal scenario if UIView.setAnimationsEnabled(worked) we would go back to
            //UIView.setAnimationsEnabled(true)
            // after the rotation
            let postOrientation = self.preferredInterfaceOrientationForPresentation
            if postOrientation.isLandscape {
                //print("Landscape post")
                self.applyLandscapeConstraints()
            } else if postOrientation.isPortrait {
                //print("Portrait  post")
                self.applyPortraitConstraints()
            } else {
                //print("postOrientation::\(postOrientation)")
            }

            
        }
    }

    //// This also doesn't work, but worth keep for discussion.
    //    override public func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    //
    //        print("a breakpoint .  Rotation has already started in Collect too!!!")
    //
    //        UIView.setAnimationsEnabled(false)
    //        super.willTransition(to: newCollection, with: coordinator)
    //        //self.updateToolbarConstraints()
    //    }

    
    
    func applyLandscapeConstraints() {
        NSLayoutConstraint.deactivate(portraitConstraints)
        print("go landscape")
        landscapeConstraints = ConstraintsHelper.applyLandscapeConstraints(view: self.view, view1: BottomView)
    }
        
    func applyPortraitConstraints() {
        print("go portrait")
        NSLayoutConstraint.deactivate(landscapeConstraints)
        view.addConstraints(portraitConstraints)
    }
    

}

