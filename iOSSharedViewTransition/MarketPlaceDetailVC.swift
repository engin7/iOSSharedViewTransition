//
//  MarketPlaceDetailVC.swift
//  iOSSharedViewTransition
//
//  Created by Engin KUK on 14.12.2020.
//

import UIKit

class MarketPlaceDetailVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var img : UIImage?
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = img
        
        // Do any additional setup after loading the view.
    }
    
    override func sharedView() -> UIView {
        return imageView
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
