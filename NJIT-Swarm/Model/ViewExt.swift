//
//  ViewExt.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 21/11/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
}
