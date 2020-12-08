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
        
        
        var fromVC = transitionContext.viewController(forKey: .from)
        var toVC = transitionContext.viewController(forKey: .to)
        
 
        
        var reversed = false
        
        let pHolder = paramHolderForFromVC(fromVC: fromVC, toVC: toVC, reversed: nil)
        
        if (pHolder == nil) {return}
        
        let fromView = fromVC?.sharedView()
        let toView = toVC?.sharedView()
        
        let containerView = transitionContext.containerView
        let dur = transitionDuration(using: transitionContext)
        
        // Take Snapshot of fomView
        let snapshotView = fromView?.snapshotView(afterScreenUpdates: false)
        snapshotView?.frame = containerView.convert(fromView!.frame, from: fromView?.superview)
        
        // Setup the initial view states
        toVC!.view.frame = transitionContext.finalFrame(for: toVC!)
        
        
        
        
        
    }
    
    
     
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }
    
}

extension UIViewController: ASFSharedViewTransitionDataSource {
    func sharedView() -> UIView {
        return view
    }
    
    
}
  



