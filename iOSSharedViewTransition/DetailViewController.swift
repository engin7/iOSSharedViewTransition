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
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImageView.image = img
    }
    
    // MARK: - ASFSharedViewTransitionDataSource

    override func sharedView() -> UIView {
        return detailImageView
    }
}
 
 
