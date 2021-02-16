//
//  MessageCollectionViewDelegates.swift
//  MessagesAppDemo
//
//  Created by Gaurav Priya on 16/02/21.
//

import UIKit

extension MessagesViewController: UICollectionViewDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView( _ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
//        let destinationIndex = coordinator.destinationIndexPath?.item ?? 0
//        
//        for item in coordinator.items {
//            if coordinator.session.localDragSession != nil,
//               let sourceIndex = item.sourceIndexPath?.item {
//                
//                self.entry?.images.remove(at: sourceIndex)
//            }
//            
//            item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) {
//                (object, error) in
//                guard let image = object as? UIImage, error == nil else {
//                    print(error ?? "Error: object is not UIImage")
//                    return
//                }
//                DispatchQueue.main.async {
//                    self.entry?.images.insert(image, at: destinationIndex)
//                    self.reloadSnapshot(animated: true)
//                }
//            }
//        }
    }

    
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//
//        let selectedMessageModel = fetchMessageModel(for: indexPath)!
//
//        let itemProvider = NSItemProvider(object: selectedMessageModel as MessageModel)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = selectedMessageModel
//    }
}
