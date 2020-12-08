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
    
    var nav :UINavigationController? = nil
    var duration: TimeInterval = 0
    var fromVCClass: NSObject?
    var toVCClass: NSObject?
    
}

class ASFSharedViewTransition: NSObject, UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning {
    
    static let shared: ASFSharedViewTransition = ASFSharedViewTransition()

    var arrParamHolders: [ParamsHolder] = []
   
    
    // MARK: - Private Methods
    
    func paramHolderForFromVC(fromVC:UIViewController?,toVC:UIViewController?, reversed: Bool?) -> ParamsHolder? {
        
        var pHolder: ParamsHolder? = nil
        let ASFShared = ASFSharedViewTransition.shared
        
        for holder in ASFShared.arrParamHolders {
            if (holder.fromVCClass == fromVC  && holder.toVCClass == toVC ) {
                pHolder = holder;
            }
            else if (holder.fromVCClass == toVC && holder.toVCClass == fromVC) {
                pHolder = holder;
                //  you should use reversed = true or nil in parameter
            }
        }
        
        return pHolder
    }
  
    // MARK: -  Public Methods

    func addTransitionWithFromViewControllerClass(aFromVCClass: ASFSharedViewTransitionDataSource, aToVCClass:ASFSharedViewTransitionDataSource, aNav:UINavigationController,aDuration:TimeInterval)
                              
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
        
        let pHolder = paramHolderForFromVC(fromVC: fromVC, toVC: toVC, reversed: nil)
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
        
        let pHolder = paramHolderForFromVC(fromVC: fromVC, toVC: toVC, reversed: nil)
        
        if (pHolder == nil) {return}
        
        let fromView = fromVC.sharedView()
        let toView = toVC.sharedView()
        
        let containerView = transitionContext.containerView
        let dur = transitionDuration(using: transitionContext)
        
        // Take Snapshot of fomView
        guard let snapshotView = fromView.snapshotView(afterScreenUpdates: false) else {return}
        snapshotView.frame = containerView.convert(fromView.frame, from: fromView.superview)
        
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
        }
//        completion: ((Bool) -> Void)?) {
//            // Clean up
//            toView.isHidden = false
//            fromView.isHidden = false
//            snapshotView.removeFromSuperview
//
//            // Declare that we've finished
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//
//            )}
    
   ) }
    
     
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }
    
}

extension UIViewController: ASFSharedViewTransitionDataSource {
    func sharedView() -> UIView {
        return view
    }
    
    
}
  



