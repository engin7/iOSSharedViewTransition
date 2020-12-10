//
//  ASFSharedViewTransition.swift
//  iOSSharedViewTransition
//
//  Created by Engin KUK on 8.12.2020.
//

import UIKit

protocol  ASFSharedViewTransitionDataSource: NSObject {
    func sharedView()-> UIView
}
 
class ParamsHolder : NSObject {
    
    var nav :UINavigationController?
    var duration: TimeInterval = 0
    var fromVCClass: UIViewController?
    var toVCClass: UIViewController?
    
}

class ASFSharedViewTransition: NSObject, UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning {
    
    static let shared: ASFSharedViewTransition = ASFSharedViewTransition()
    
    var arrParamHolders: [ParamsHolder] = []
   
    // MARK: - Private Methods
    
    func paramHolderForFromVC(fromVC:UIViewController?,toVC:UIViewController?, reversed: inout Bool) -> ParamsHolder? {
        
        var pHolder: ParamsHolder? = nil
        let ASFShared = ASFSharedViewTransition.shared
        
        for holder in ASFShared.arrParamHolders {
            if type(of:holder.fromVCClass) == type(of:fromVC)  && type(of:holder.toVCClass) == type(of:toVC) {
                pHolder = holder
            }
            else if type(of:holder.fromVCClass) == type(of:toVC)  && type(of:holder.toVCClass) == type(of:fromVC) {
                pHolder = holder
                
                if !reversed {
                    reversed = true
                }
            }
            
        }
        
        return pHolder
    }
  
    // MARK: -  Public Methods

    func addTransitionWithFromViewControllerClass(aFromVCClass: UIViewController, aToVCClass:UIViewController, aNav:UINavigationController,aDuration:TimeInterval)
    {
        var found = false
        let ASFShared = ASFSharedViewTransition.shared

        for holder in ASFShared.arrParamHolders {
            if (holder.fromVCClass == aFromVCClass && holder.toVCClass == aToVCClass) {
                holder.duration = aDuration
                holder.nav = aNav
                holder.nav?.delegate = ASFSharedViewTransition.shared
                
                found = true
                break
            }
        }
        
        if !found {
            let holder = ParamsHolder()
            holder.fromVCClass = aFromVCClass
            holder.toVCClass = aToVCClass
            holder.duration = aDuration
            holder.nav = aNav
            
            holder.nav?.delegate = ASFSharedViewTransition.shared
            ASFSharedViewTransition.shared.arrParamHolders.append(holder)
        }
    }
    
    // MARK: -  UINavigationControllerDelegate Methods

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var reversedDummy = false
        let pHolder = paramHolderForFromVC(fromVC: fromVC, toVC: toVC, reversed: &reversedDummy)
        if (pHolder != nil) {
            return ASFSharedViewTransition.shared
        }
        else {
            return nil
        }
    }
     
    // MARK: - UIViewControllerContextTransitioning
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from) else {return}
        guard let toVC = transitionContext.viewController(forKey: .to) else {return}
         
        var reversed = false
        
        let pHolder = paramHolderForFromVC(fromVC: fromVC, toVC: toVC, reversed: &reversed)
          
        if (pHolder == nil) {return}
        
        let fromView = fromVC.sharedView()
        let toView = toVC.sharedView()
        
        let containerView = transitionContext.containerView
        let dur = transitionDuration(using: transitionContext)
        
        // Take Snapshot of fomView
        guard let snapshotImage = fromView.caSnapshot() else {return}
        let snapshotView = UIImageView(image: snapshotImage)
        snapshotView.frame = containerView.convert(fromView.frame, from: fromView.superview)
//        print(fromView.superview?.frame)
//        print(fromVC.view)

        fromView.isHidden = true
        
        // Setup the initial view states
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        
        if (!reversed) {
            toVC.view.alpha = 0
            toView.isHidden = true
            containerView.addSubview(toVC.view)
        }
        else {
            containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        }
        
        containerView.addSubview(snapshotView)
       
        UIView.animate(withDuration: dur, animations:  {
            if (!reversed) {
               toVC.view.alpha = 1.0; // Fade in
           }
           else {
               fromVC.view.alpha = 0.0; // Fade out
           }
            // Move the SnapshotView
            snapshotView.frame = containerView.convert(toView.frame, from: toView.superview)

        },   completion:  { _ in
            // Clean up
            toView.isHidden = false
            fromView.isHidden = false
            snapshotView.removeFromSuperview()

            // Declare that we've finished
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)

            }
    
   ) }
     
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        guard let fromVC = transitionContext?.viewController(forKey: .from) else {return 0}
        guard let toVC = transitionContext?.viewController(forKey: .to) else {return 0}
        
        var reversedDummy = false
        let pHolder = paramHolderForFromVC(fromVC: fromVC, toVC: toVC, reversed: &reversedDummy)

        if (pHolder != nil) {
            return pHolder!.duration
        }
        else {
            return 0
        }
    }
    
}
 
extension UIViewController: ASFSharedViewTransitionDataSource {
    @objc func sharedView() -> UIView {
            return view
       }
}
  
extension UIView {

   /// The method drawViewHierarchyInRect:afterScreenUpdates: performs its operations on the GPU as much as possible
   /// In comparison, the method renderInContext: performs its operations inside of your app’s address space and does
   /// not use the GPU based process for performing the work.
   /// https://stackoverflow.com/a/25704861/1418981
   public func caSnapshot(scale: CGFloat = 0, isOpaque: Bool = false) -> UIImage? {
      var isSuccess = false
      UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, scale)
      if let context = UIGraphicsGetCurrentContext() {
         layer.render(in: context)
         isSuccess = true
      }
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return isSuccess ? image : nil
   }
}


