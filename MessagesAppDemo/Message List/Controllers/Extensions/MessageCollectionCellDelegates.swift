//
//  MessageCollectionCellDelegates.swift
//  MessagesAppDemo
//
//  Created by Gaurav Priya on 16/02/21.
//

import UIKit

extension MessagesViewController:
    UnPinnedCollectionCellDelegate, PinnedCollectionCellDelegate {
    
    func pinButtonTapped(for unPinnedCell: UnPinnedCollectionCell) {
        let tappedIndexPath = collectionView.indexPath(for: unPinnedCell)
        togglePinStateForMessage(for: tappedIndexPath!)
    }
    
    func unPinButtonTapped(for pinnedCell: PinnedCollectionCell) {
        let tappedIndexPath = collectionView.indexPath(for: pinnedCell)
        togglePinStateForMessage(for: tappedIndexPath!)
    }
    
    func togglePinStateForMessage(for selectedIndexPath: IndexPath) {
        
        let tappedMessageID: Int! = fetchMessageModel(for: selectedIndexPath)!.messageID
        
        for i in 0..<mainMessageModel.messageModels.count {
            if mainMessageModel.messageModels[i].messageID == tappedMessageID {
                
                if mainMessageModel.messageModels[i].isPinned == false {
                    if mainMessageModel.totalPinnedMessages < 9 {
                        mainMessageModel.totalPinnedMessages += 1 //as it means it is going to be oinned in next line
                        mainMessageModel.messageModels[i].isPinned = !mainMessageModel.messageModels[i].isPinned
                    } else {
                        let alert = UIAlertController(title: "Sorry!", message: "You can pin only up to 9 chats", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert,
                                     animated: true,
                                     completion: nil
                        )
                    }
                } else {
                    mainMessageModel.totalPinnedMessages -= 1
                    mainMessageModel.messageModels[i].isPinned = !mainMessageModel.messageModels[i].isPinned
                }
            }
        }
        
        reloadCollectionView()
    }
}
