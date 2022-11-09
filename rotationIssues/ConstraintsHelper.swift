//
//  ConstraintsHelper.swift
//  rotationIssues
//
//  Created by Graham Myhre on 10/25/22.
//

import Foundation
import UIKit

class ConstraintsHelper {
    
    static func applyLandscapeConstraints(view: UIView, view1: UIView) -> [NSLayoutConstraint] {
        var landscapeConstraints = [NSLayoutConstraint]()
        
        view1.translatesAutoresizingMaskIntoConstraints = false
        
        var c1 = view1.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        var c2 = view1.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        var c3 = view1.widthAnchor.constraint(equalToConstant: 100)
        var c4 = view1.heightAnchor.constraint(equalTo: view.widthAnchor)
        let constraints = [c1, c2, c3, c4]
        
        NSLayoutConstraint.activate(constraints)
                
        landscapeConstraints.append(c1)
        landscapeConstraints.append(c2)
        landscapeConstraints.append(c3)
        landscapeConstraints.append(c4)

        return landscapeConstraints
    }
}
