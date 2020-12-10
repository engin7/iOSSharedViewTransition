//
//  ViewController.swift
//  iOSSharedViewTransition
//
//  Created by Engin KUK on 8.12.2020.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var arrImages: [UIImage] = []
    
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
    
    override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              if (segue.identifier == SegueTo.showDetails.rawValue) {
                  let vc = segue.destination as! DetailViewController
                vc.img = sender as? UIImage
              }
          }
    
    // MARK: - UICollectionViewDelegate protocol
 
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           // handle tap events
        let image = arrImages[indexPath.row]
            self.performSegue(withIdentifier: SegueTo.showDetails.rawValue, sender: image)
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for _ in 0...3 {
            for i in 1...8 {
                arrImages.append(UIImage(named: "nature\(i).jpg")!)
            }
        }
    }
 
    // MARK: - ASFSharedViewTransitionDataSource

    override func sharedView() -> UIView {
        let index = self.collectionView.indexPathsForSelectedItems?.first
        return collectionView(collectionView, cellForItemAt: index!)
    }
    
}

extension ViewController {
    private enum SegueTo: String {
        case showDetails = "DetailViewController"
    }
}
