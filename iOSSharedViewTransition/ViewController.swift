//
//  ViewController.swift
//  iOSSharedViewTransition
//
//  Created by Engin KUK on 8.12.2020.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    var arrImages: [UIImage] = []
    
    // MARK: - UICollectionViewDelegate protocol
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for _ in 0...1 {
            for i in 1...8 {
                arrImages.append(UIImage(named: "nature\(i).jpg")!)
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource protocol

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        cell.layer.contents = arrImages[indexPath.row].cgImage
        return cell
    }
    
    // MARK: - Navigation
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MarketPlaceDetailVC") as? MarketPlaceDetailVC else {
                        fatalError("MarketPlaceDetailVC could not be initialized with storyboard")
                    }
        
         
        
        if let selectedIndexPath = self.myCollectionView.indexPathsForSelectedItems?.first {
            vc.img = arrImages[selectedIndexPath.row]
        }
         
        navigationController?.modalPresentationStyle = UIModalPresentationStyle.overFullScreen

        navigationController?.pushViewController(vc, animated: true)
         
    }
    
    
    
//    for storyboard segue:
    
//    override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if type(of:segue.destination) == type(of:DetailViewController()) {
//            if let selectedIndexPath = self.myCollectionView.indexPathsForSelectedItems?.first {
//                  let vc = segue.destination as! DetailViewController
//                  vc.img = arrImages[selectedIndexPath.row]
//            }
//        }
//    }
     
    override func sharedView() -> UIView {
        if let index = self.myCollectionView.indexPathsForSelectedItems?.first {
            if let view = myCollectionView.cellForItem(at: index) {
                return view
            }
        }
        return view
    }
    
}
 
