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

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
     
    var arrParamHolders: [ParamsHolder] = []
   
    
    // MARK: - Private Methods
    
    func paramHolderForFromVC(fromVC:UIViewController?,toVC:UIViewController?, reversed: Bool ) -> ParamsHolder? {
        
        var pHolder: ParamsHolder? = nil
        let ASFShared = ASFSharedViewTransition.shared
        
        for holder in ASFShared.arrParamHolders {
            if (holder.fromVCClass == fromVC  && holder.toVCClass == toVC ) {
                pHolder = holder;
            }
            else if (holder.fromVCClass == toVC && holder.toVCClass == fromVC) {
                pHolder = holder;
            
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
    
    
    
    
    
    
}





