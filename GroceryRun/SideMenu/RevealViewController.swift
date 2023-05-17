//
//  RevealViewController.swift
//  GroceryRun
//
//  Created by Jordan on 2019-06-17.
//  Copyright © 2019 Jordan. All rights reserved.
//

import UIKit
import SWRevealViewController

class RevealViewController: SWRevealViewController, SWRevealViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.tapGestureRecognizer()
        self.panGestureRecognizer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK : - SWRevealViewControllerDelegate
    
    func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
        if position == FrontViewPosition.right {
            self.frontViewController.view.isUserInteractionEnabled = false
        }
        else {
            self.frontViewController.view.isUserInteractionEnabled = true
        }
    }
}
