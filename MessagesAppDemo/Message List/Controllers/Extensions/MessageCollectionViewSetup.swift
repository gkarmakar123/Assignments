//
//  MessageCollectionView.swift
//  MessagesAppDemo
//
//  Created by Gaurav Priya on 16/02/21.
//

import UIKit

extension MessagesViewController {
    
    enum CollectionCellType: CaseIterable {
        case pinnedCell
        case unPinnedCell
    }

    //MARK:- Computed properties for collection view
    var pinnedMessageModels: [MessageModel]! {
        return mainMessageModel.messageModels.filter {$0.isPinned == true}
    }
    var unPinnedMessageModels: [MessageModel]! {
        return mainMessageModel.messageModels.filter {$0.isPinned == false}
    }

    //MARK:-
    func createCollectionView() -> UICollectionView {
        
        let theCollectionView = UICollectionView(frame: .zero, collectionViewLayout: { () -> UICollectionViewLayout in

            let theCollectionLayout = UICollectionViewCompositionalLayout { [unowned self]
                (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                
                let sectionType = CollectionCellType.allCases[sectionIndex]
                
                switch(sectionType) {
                
                case .pinnedCell:
                    return self.pinnedCellLayout()
                case .unPinnedCell:
                    return self.unPinnedCellLayout(with: layoutEnvironment)
                }
            }
            
            return theCollectionLayout
        }())
        
        theCollectionView.translatesAutoresizingMaskIntoConstraints = false
        theCollectionView.backgroundColor = .white
//        theCollectionView.dragDelegate = self
        theCollectionView.delegate = self
        theCollectionView.dragInteractionEnabled = true
        
        theCollectionView.register(
            PinnedCollectionCell.self,
            forCellWithReuseIdentifier: PinnedCollectionCell.reuseIdentifier
        )
        theCollectionView.register(
            UnPinnedCollectionCell.self,
            forCellWithReuseIdentifier: UnPinnedCollectionCell.reuseIdentifier
        )
        
        return theCollectionView
    }
        
    //MARK:- Collection Cell Layouts
    private func pinnedCellLayout() -> NSCollectionLayoutSection {
        
        let itemWidth = Constants.PinnedCell.itemWidth()
        let groupHeight = Constants.PinnedCell.groupHeight()
        
        let pinnedItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(itemWidth),//.fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0)))
        pinnedItem.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.PinnedCell.itemTopEdge,
            leading: Constants.PinnedCell.itemLeadingEdge,
            bottom: Constants.PinnedCell.itemBottomEdge,
            trailing: Constants.PinnedCell.itemTrailingEdge
        )
        
        let pinnedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(groupHeight)),
            subitem: pinnedItem,
            count: Constants.PinnedCell.itemRowCount())
        pinnedGroup.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.PinnedCell.groupTopEdge,
            leading: Constants.PinnedCell.groupLeadingEdge,
            bottom: Constants.PinnedCell.groupBottomEdge,
            trailing: Constants.PinnedCell.groupTrailingEdge
        )
        
        let pinnedSection = NSCollectionLayoutSection(group: pinnedGroup)
        return pinnedSection
    }
    
    private func unPinnedCellLayout(with environment:NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let cellItemEdgeInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 0)
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.trailingSwipeActionsConfigurationProvider = {[unowned self] indexPath in

            let selectedItem = self.collectionViewDataSource.itemIdentifier(for: indexPath)
            return self.deleteItemOnSwipe(item: selectedItem!)

        }
        
        let unPinnedSection = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
        
        return unPinnedSection
    }
    
    private func deleteItemOnSwipe(item: MessageModel) -> UISwipeActionsConfiguration? {
            
            let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: {[unowned self] action, view, completion in
                
                completion(true)
                
                mainMessageModel.messageModels.remove(at: getIndex(for: item))
                reloadCollectionView()
            })
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .red
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    //MARK:- Utility methods
    
    func fetchMessageModel(for selectedIndexPath: IndexPath) -> MessageModel? {
        var selectedMessageModel: MessageModel?
        
        switch selectedIndexPath.section {
        
        case 0:
            selectedMessageModel = pinnedMessageModels[selectedIndexPath.row]
        case 1:
            selectedMessageModel = unPinnedMessageModels[selectedIndexPath.row]
        default:
            print("Not possible condition reached")
        }

        return selectedMessageModel
    }
    
    func getIndex(for messageModel: MessageModel) -> Int {
        let filteredIndices = mainMessageModel.messageModels.indices.filter{mainMessageModel.messageModels[$0] == messageModel}
        
        return filteredIndices[0]
    }
    
    func reloadCollectionView() {
        var newSnapshot = collectionViewDataSource.snapshot()
        newSnapshot.deleteAllItems()
        newSnapshot.appendSections([CollectionCellType.pinnedCell, CollectionCellType.unPinnedCell])
        newSnapshot.appendItems(pinnedMessageModels, toSection: CollectionCellType.pinnedCell)
        newSnapshot.appendItems(unPinnedMessageModels, toSection: CollectionCellType.unPinnedCell)

        collectionViewDataSource.apply(newSnapshot, animatingDifferences: true)
        collectionView.reloadData()
    }
    
    //MARK:- Collection View Data Source
    func configureCollectionDataSource() {
        collectionViewDataSource = UICollectionViewDiffableDataSource<CollectionCellType, MessageModel>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, messageModel: MessageModel) -> UICollectionViewCell? in
            
            let sectionType = CollectionCellType.allCases[indexPath.section]
            
            switch(sectionType) {
            
            case .pinnedCell:
                guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: PinnedCollectionCell.reuseIdentifier,
                        for: indexPath) as? PinnedCollectionCell
                else {
                    fatalError("Could not create new cell")
                }
                cell.delegate = self
                cell.loadCell(with: messageModel)
                return cell
                
            case .unPinnedCell:
                guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: UnPinnedCollectionCell.reuseIdentifier,
                        for: indexPath) as? UnPinnedCollectionCell
                else {
                    fatalError("Could not create new cell")
                }
                cell.delegate = self
                cell.loadCell(with: messageModel)
                return cell
            }
        }
        
        collectionViewDataSource.reorderingHandlers.canReorderItem = {item in return true}
        
        let snapshot = { () -> NSDiffableDataSourceSnapshot<CollectionCellType, MessageModel> in
            var snapshot = NSDiffableDataSourceSnapshot<CollectionCellType, MessageModel>()
            snapshot.appendSections([CollectionCellType.pinnedCell, CollectionCellType.unPinnedCell])
            snapshot.appendItems(pinnedMessageModels, toSection: CollectionCellType.pinnedCell)
            snapshot.appendItems(unPinnedMessageModels, toSection: CollectionCellType.unPinnedCell)
            
            return snapshot
        }()
        
        collectionViewDataSource.apply(snapshot, animatingDifferences: true)
    }

    
    
    //MARK:- Long Press Gesture And Handling
    func configureLongPressGesture() {
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }

}
