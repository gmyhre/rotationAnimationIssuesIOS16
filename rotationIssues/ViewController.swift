//
//  ViewController.swift
//  rotationIssues
//
//  Created by Graham Myhre on 10/24/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var RectangleView: UIView!
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var HiBtn: UIButton!
    
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rectViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rectViewWidth: NSLayoutConstraint!
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
        
        // don't change width and height
        portraitConstraints.append(bottomViewTrailing)
        portraitConstraints.append(bottomViewLeading)
        portraitConstraints.append(bottomViewBottom)

        self.lastSupportedInterfaceOrientation = self.currentSupportedOrientation
        
        
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


        UIView.setAnimationsEnabled(false)  // works for basic animations, but not roations
        

    }
    
    
    
    
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        UIView.setAnimationsEnabled(false)

        super.viewWillTransition(to: size, with: coordinator)
        print("viewWillTransition called")
        
        let anOrientation = self.preferredInterfaceOrientationForPresentation
        //print("something\(anOrientation)")
        if anOrientation.isLandscape {
            //print("Landscape")
            
        } else if anOrientation.isPortrait {
            //print("Portrait pre")
            
        } else {
            //print("something else")
        }
        //print("a breakpoint .  Rotation Animation has already started in iOS 16 but not in iOS 15 and below!!!")
        // Put code to be run BEFORE the rotation here...

        
        coordinator.animate(alongsideTransition: nil) { _ in
            // Put code to be run after the rotation,
            // or after frame-size change here...
            
            //UIView.setAnimationsEnabled(true)
            
            
            let postOrientation = self.preferredInterfaceOrientationForPresentation


            if postOrientation.isLandscape {
                //print("Landscape post")
                
                self.applyLandscapeConstraints()
            } else if postOrientation.isPortrait {
                //print("Portrait  post")
                self.applyPortraitConstraints()
            } else {
                //print("something else post")
            }

            //self.rotateInPlace()
            
            
            // this style is not deprecated UIDevice.current.orientation.isLandscape {
                //print("Landscape post")
            //UIView.setAnimationsEnabled(true)
            // shouldn't work because animations are false
            
        }
    }
    
    
    
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
    

    
    
    @objc func orientationChanged(notification: NSNotification) {
        print("not using this one")
            //let deviceOrientation = UIApplication.share.statusBarOrientation

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, windowScene.activationState == .foregroundActive, let window = windowScene.windows.first else { return }

        let deviceOrientation = windowScene.interfaceOrientation
    
        switch deviceOrientation {
        case .portrait:
            fallthrough
        case .portraitUpsideDown:
            print("Portrait")
            self.applyPortraitConstraints()
            
        case .landscapeLeft:
            fallthrough
        case .landscapeRight:
            print("landscape")
            self.applyLandscapeConstraints()
        case .unknown:
            print("unknown orientation")
        @unknown default:
            print("unknown case in orientation change")
                
        }
    }

    
    
    
    //Class methods
    static func angleToRotate(fromOrientation : UIInterfaceOrientation, toOrientation : UIInterfaceOrientation) -> CGFloat {
        
        guard fromOrientation != toOrientation else {
            return 0
        }
        var rotationAngle : CGFloat = 0
        
        if toOrientation == .landscapeRight {
            if(fromOrientation == .landscapeLeft) {
                rotationAngle = -(CGFloat(Double.pi))
            }
            else {
                rotationAngle = -(CGFloat(Double.pi) / 2)
            }
        }
        else if toOrientation == .landscapeLeft {
            if(fromOrientation == .landscapeRight) {
                rotationAngle = (CGFloat(Double.pi))
            }
            else {
                rotationAngle = (CGFloat(Double.pi) / 2)
            }
        }
        else if toOrientation == .portrait {
            if(fromOrientation == .landscapeLeft) {
                rotationAngle = -(CGFloat(Double.pi) / 2)
            }
            else if(fromOrientation == .landscapeRight) {
                rotationAngle = CGFloat(Double.pi) / 2
            }
        }
        return rotationAngle
    }

    


    
    

}

