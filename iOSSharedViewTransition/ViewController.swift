//
//  ViewController.swift
//  iOSSharedViewTransition
//
//  Created by Engin KUK on 8.12.2020.
//

import UIKit

class ViewController: UIViewController, ASFSharedViewTransitionDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    
    
    
    
    
    
    // MARK: - ASFSharedViewTransitionDataSource
     
    func sharedView() -> UIView {
        return view
    }
    
}

