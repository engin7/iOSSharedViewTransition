//
//  DetailViewController.swift
//  iOSSharedViewTransition
//
//  Created by Engin KUK on 9.12.2020.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    var img : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImageView.image = img
        // Do any additional setup after loading the view.
    }

     
    
    // MARK: - ASFSharedViewTransitionDataSource
     
   
    
}
