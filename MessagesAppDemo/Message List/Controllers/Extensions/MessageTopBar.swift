//
//  MessageTopBar.swift
//  MessagesAppDemo
//
//  Created by Gaurav Priya on 16/02/21.
//

import Foundation

extension MessagesViewController: TopBarViewDelegate {
    func editButtonTapped() {
        mainMessageModel.allInEditMode = true
        reloadCollectionView()
        self.setEditing(true, animated: true)
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated:animated)
        self.collectionView.isEditing = editing
    }
    func doneButtonTapped() {
        mainMessageModel.allInEditMode = false
        reloadCollectionView()
        self.setEditing(false, animated: true)
    }
    
}
