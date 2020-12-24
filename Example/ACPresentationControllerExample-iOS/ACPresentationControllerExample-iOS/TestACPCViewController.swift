//
//  TestACPCViewController.swift
//  TestACLib
//
//  Created by ac_m1a on 2020/12/19.
//

import UIKit

import ACPresentationController

class TestACPCViewController: UIViewController, ACPresentationControllerProtocol {
        
    // MARK: property
    public let testLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = .white
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.text = "test panIndicator hierarchy"
        return label
    }()
    
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
    var acpc_topGrabberHeight: CGFloat {
        return 20.0
    }
    var acpc_needFullTopGrabber: Bool {
        return true
    }
    var acpc_topGrabberSendToBack: Bool {
        return true
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .yellow
        
        self.view.addSubview(testLabel)
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            testLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            testLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            testLabel.heightAnchor.constraint(equalToConstant: 44.0)
        ])
    }

}
