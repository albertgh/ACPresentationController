//
//  TestACPCViewController.swift
//  TestACLib
//
//  Created by ac_m1a on 2020/12/19.
//

import UIKit

import ACPresentationController

class TestACPCViewController: UIViewController, ACPresentationControllerProtocol {
        
    // MARK: ACCommonPresentationProtocol
    var acpc_dismissClosure: (() -> Void)?
    var acpc_controllerHeight: CGFloat = 480.0

    var acpc_dimmingAlpha: CGFloat {
        return 0.5
    }
    var acpc_panToDismissPercent: CGFloat {
        return 0.4
    }
    
    var acpc_grabberColor: UIColor {
        return .white
    }
    var acpc_needFullTopGrabber: Bool {
        return true
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .yellow
    }

}
