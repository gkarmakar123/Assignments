//
//  Constants.swift
//  MessagesAppDemo
//
//  Created by Gaurav Karmakar on 14/02/21.
//

import Foundation
import CoreGraphics
import UIKit

struct Constants {
//    static let screenWidth = UIScreen.main.bounds.width
//    static let screenHeight = UIScreen.main.bounds.height
    
    static let edgeInset: CGFloat = 15.0
    
    //MARK:- For Pinned Cell
    struct PinnedCell {
        static let itemLeadingEdge: CGFloat = 15.0
        static let itemTrailingEdge: CGFloat = 15.0
        static let itemTopEdge: CGFloat = 10.0
        static let itemBottomEdge: CGFloat = 10.0

        static let groupLeadingEdge: CGFloat = 15.0
        static let groupTrailingEdge: CGFloat = 15.0
        static let groupTopEdge: CGFloat = 0.0
        static let groupBottomEdge: CGFloat = 0.0

//        static let senderImageDiameter: CGFloat = 135.0

        static var maxItemCount = 9
        
        static func itemRowCount() -> Int {
            var rowCount = 3
            if UIDevice.current.orientation.isLandscape {
                rowCount = 9
            }
            
            return rowCount
        }
        
        static func itemWidth() -> CGFloat {
            var itemWidth: CGFloat = 0.0
            
            let itemCount = CGFloat(Constants.PinnedCell.itemRowCount())
            let screenWidth = UIScreen.main.bounds.width
            
            let spaceForGroupEdges = Constants.PinnedCell.groupLeadingEdge + Constants.PinnedCell.groupTrailingEdge
            let spaceForItemLeadingEdges = itemCount * Constants.PinnedCell.itemLeadingEdge
            let spaceForItemTrailingEdges = itemCount * Constants.PinnedCell.itemTrailingEdge
            
            let sumOfAllEdges = spaceForGroupEdges + spaceForItemLeadingEdges + spaceForItemTrailingEdges
                
            itemWidth = (screenWidth - sumOfAllEdges) / itemCount
            
            return itemWidth
        }
        
        static func groupHeight() -> CGFloat {
            return Constants.PinnedCell.itemTopEdge + Constants.PinnedCell.itemWidth() + 50.0 + Constants.PinnedCell.itemBottomEdge
        }
    }
    
    //MARK:- For UnPinned Cell
    struct UnPinnedCell {
        static let senderImageDiameter: CGFloat = 70.0
        
    }
    
    //MARK:- Common For Both Cells
    static let unreadDotColor = UIColor.init(red: 44/255, green: 125/255, blue: 241/255, alpha: 1.0)
    static let unreadDotImageDiameter: CGFloat = 15.0
}
