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
            let temporaryArray = modifiedMessageModels.filter({$0.senderName.lowercased().range(of: searchText.lowercased()) != nil})
            modifiedMessageModels = temporaryArray
            reloadCollectionView()
            
        } else {
            modifiedMessageModels = modifiedMessageModelBackup
            reloadCollectionView()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        modifiedMessageModelBackup = modifiedMessageModels
        searchBar.enablesReturnKeyAutomatically = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        
        if searchText.isEmpty {
            modifiedMessageModels = modifiedMessageModelBackup
            modifiedMessageModelBackup = nil
            reloadCollectionView()
        }
    }
}
