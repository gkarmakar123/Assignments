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
    }
    
    func doneButtonTapped() {
        mainMessageModel.allInEditMode = false
        reloadCollectionView()
    }
    
}
