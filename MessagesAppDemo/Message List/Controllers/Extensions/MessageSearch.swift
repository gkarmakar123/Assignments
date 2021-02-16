//
//  MessageSearch.swift
//  MessagesAppDemo
//
//  Created by Gaurav Priya on 16/02/21.
//

import UIKit

extension MessagesViewController: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0  {
            let temporaryArray = mainMessageModel.messageModels.filter({$0.senderName.lowercased().range(of: searchText.lowercased()) != nil})
            mainMessageModel.messageModels = temporaryArray
            reloadCollectionView()
            
        } else {
            mainMessageModel.messageModels = mainMessageModel.messageModelsBackup
            reloadCollectionView()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        mainMessageModel.messageModelsBackup = mainMessageModel.messageModels
        searchBar.enablesReturnKeyAutomatically = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        
        if searchText.isEmpty {
            mainMessageModel.messageModels = mainMessageModel.messageModelsBackup
            mainMessageModel.messageModelsBackup = nil
            reloadCollectionView()
        }
    }
}
