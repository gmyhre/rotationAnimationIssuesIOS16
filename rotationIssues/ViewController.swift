//
//  ViewController.swift
//  rotationIssues
//
//  Created by Graham Myhre on 10/24/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    private var deviceOrientationObservation: NSObjectProtocol?


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
        
        //For solution we now completely move away from setAnimationEnabled
        // set it here for obvious example
        //UIView.setAnimationsEnabled(false)  // works for basic animations, but not roations
        
        //Solution
        /// When the view is appearing, start listening to device orientation changes...
        deviceOrientationObservation = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification,
                                                                              object: UIDevice.current,
                                                                              queue: .main, using: { [weak self] _ in

            /// When the device orientation changes to a valid interface orientation, save the current orientation as our current supported orientations.
            if let self, let mask = UIInterfaceOrientationMask(deviceOrientation: UIDevice.current.orientation), self.currentSupportedOrientations != mask {
                self.currentSupportedOrientations = mask
                
                // solution added
    
                // after the rotation
                print("mask is updated:: \(mask)")
                if (mask == .landscapeLeft || mask == .landscapeRight) {
                    //print("Landscape post")
                    self.applyLandscapeConstraints()
                } else if (mask == .portrait) {
                    //print("Portrait  post")
                    self.applyPortraitConstraints()
                } else {
                    //print("postOrientation::\(postOrientation)")
                }

                
                
                
            }
        })
        

    }
    
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// Stop observing when the view disappears
        deviceOrientationObservation = nil


    }

    
    private var currentSupportedOrientations: UIInterfaceOrientationMask = .portrait {
        didSet {
            /// When the current supported orientations changes, call `setNeedsUpdate...` within a `performWithoutAnimation` block.
            /// This will trigger the system to read the `supportedInterfaceOrientations` of this view controller again and apply any changes
            /// without animation, but still async. If you are counter rotating an UI, that should still be done in `viewWillTransitionToSize`
            UIView.performWithoutAnimation {
                if #available(iOS 16.0, *) {
                    setNeedsUpdateOfSupportedInterfaceOrientations()
                } else {
                    print("get ready to fork")
                    // Fallback on earlier versions
                }
            }
        }
    }

    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return currentSupportedOrientations
    }
    
    
    
    //TODO: Solution no longer uses viewWillTransition
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//
//        // redundant
//        //UIView.setAnimationsEnabled(false)
//
//        super.viewWillTransition(to: size, with: coordinator)
//        print("viewWillTransition called")
//        //print("a breakpoint .  Rotation Animation has already started in iOS 16 but not in iOS 15 and below!!!")
//        // Put code to be run BEFORE the rotation here...
//
//
//        coordinator.animate(alongsideTransition: nil) { _ in
//            // Put code to be run after the rotation,
//            // or after frame-size change here...
//
//            // In an ideal scenario if UIView.setAnimationsEnabled(worked) we would go back to
//            //UIView.setAnimationsEnabled(true)
//            // after the rotation
//            let postOrientation = self.preferredInterfaceOrientationForPresentation
//            if postOrientation.isLandscape {
//                //print("Landscape post")
//                self.applyLandscapeConstraints()
//            } else if postOrientation.isPortrait {
//                //print("Portrait  post")
//                self.applyPortraitConstraints()
//            } else {
//                //print("postOrientation::\(postOrientation)")
//            }
//
//
//        }
//    }

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


//WHY OHH WHY...
//Important info apple dev docs!
//Notice that UIDeviceOrientation.landscapeRight is assigned to UIInterfaceOrientation.landscapeLeft and UIDeviceOrientation.landscapeLeft is assigned to UIInterfaceOrientation.landscapeRight. The reason for this is that rotating the device requires rotating the content in the opposite direction.

extension UIInterfaceOrientationMask {
    init?(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait:
            self = .portrait
        /// Landscape device orientation is the inverse of the interface orientation (see docs: https://developer.apple.com/documentation/uikit/uiinterfaceorientation)
            ///
        case .landscapeLeft:
            self = .landscapeRight
        case .landscapeRight:
            self = .landscapeLeft
        default:
            return nil
        }
    }
}
