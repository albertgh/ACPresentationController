//
//  ViewController.swift
//  ACPresentationControllerExample-iOS
//
//  Created by ac_m1a on 2020/12/20.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func testACPC(_ sender: Any) {
        let testACPC = TestACPCViewController()
        testACPC.acpc_dismissClosure = { 
            debugPrint("acpc_dismissClosure")
        }
        self.acpc_showPresentation(testACPC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

