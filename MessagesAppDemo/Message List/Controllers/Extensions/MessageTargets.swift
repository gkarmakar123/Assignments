//
//  MessageTargets.swift
//  MessagesAppDemo
//
//  Created by Gaurav Priya on 16/02/21.
//

import UIKit

extension MessagesViewController {
    @objc func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        //
        ////        case .began:
        ////            <#code#>
        ////        case .changed:
        ////            <#code#>
        case .ended:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gestureRecognizer.location(in: collectionView))
            else {
                return
            }
            
            togglePinStateForMessage(for: selectedIndexPath)

        default:
            print("")
        }
    }
}
