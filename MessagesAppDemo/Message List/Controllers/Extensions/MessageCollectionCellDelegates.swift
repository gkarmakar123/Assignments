//
//  MessageCollectionCellDelegates.swift
//  MessagesAppDemo
//
//  Created by Gaurav Priya on 16/02/21.
//

import Foundation

extension MessagesViewController: UnPinnedCollectionCellDelegate, PinnedCollectionCellDelegate {
    func pinButtonTapped(for unPinnedCell: UnPinnedCollectionCell) {
        let tappedIndexPath = collectionView.indexPath(for: unPinnedCell)
        togglePinStateForMessage(for: tappedIndexPath!)
    }
    
    func unPinButtonTapped(for pinnedCell: PinnedCollectionCell) {
        let tappedIndexPath = collectionView.indexPath(for: pinnedCell)
        togglePinStateForMessage(for: tappedIndexPath!)
    }
    
    func togglePinStateForMessage(for selectedIndexPath: IndexPath) {
        
        var tappedMessageID: Int!
        
        switch selectedIndexPath.section {
        
        case 0:
            tappedMessageID = pinnedMessageModels[selectedIndexPath.row].messageID
        case 1:
            tappedMessageID = unPinnedMessageModels[selectedIndexPath.row].messageID
        default:
            print("Not possible condition reached")
            
        }
        for i in 0..<modifiedMessageModels.count {
            if modifiedMessageModels[i].messageID == tappedMessageID {
                
                if modifiedMessageModels[i].isPinned == false {
                    if originalMessageModels.totalPinnedMessages < 9 {
                        originalMessageModels.totalPinnedMessages += 1 //as it means it is going to be oinned in next line
                        modifiedMessageModels[i].isPinned = !modifiedMessageModels[i].isPinned
                    } else {
                        let alert = UIAlertController(title: "Sorry!", message: "You can pin only up to 9 chats", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert,
                                     animated: true,
                                     completion: nil
                        )
                    }
                } else {
                    originalMessageModels.totalPinnedMessages -= 1
                    modifiedMessageModels[i].isPinned = !modifiedMessageModels[i].isPinned
                }
            }
        }
        
        reloadCollectionView()
    }
}
