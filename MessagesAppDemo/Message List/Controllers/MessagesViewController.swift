//
//  ViewController.swift
//  MessagesAppDemo
//
//  Created by Gaurav Karmakar on 12/02/21.
//

import UIKit

class MessagesViewController: UIViewController {
    
    private lazy var topBar: TopBarView = {
        let theTopBar = TopBarView()
        theTopBar.translatesAutoresizingMaskIntoConstraints = false
        theTopBar.backgroundColor = .white
        theTopBar.delegate = self
        return theTopBar
    }()
    
    private lazy var searchBar: UISearchBar = {
        let theSearchBar = UISearchBar()
        theSearchBar.translatesAutoresizingMaskIntoConstraints = false
        theSearchBar.placeholder = "Search"
        theSearchBar.delegate = self
        theSearchBar.backgroundImage = UIImage()
        theSearchBar.returnKeyType = .done
//        theSearchBar.setImage(UIImage(named: "pen_icon"), for: .bookmark, state: .normal)
        return theSearchBar
    }()
    
    //MARK: CollectionView Properties
    private enum CollectionCellType: CaseIterable {
        case pinnedCell
        case unPinnedCell
    }
    
    private var collectionView: UICollectionView!
    
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<CollectionCellType, MessageModel>! = nil
    
    //Data Model Objects
    private var originalMessageModels: MessageModels! {
        didSet {
            if modifiedMessageModels == nil || modifiedMessageModels.count == 0 {
                modifiedMessageModels = originalMessageModels.messageListData
            }
        }
    }
    private var modifiedMessageModels: [MessageModel]!
    private var modifiedMessageModelBackup: [MessageModel]!
    private var pinnedMessageModels: [MessageModel]! {
        return modifiedMessageModels.filter {$0.isPinned == true}
    }
    private var unPinnedMessageModels: [MessageModel]! {
        return modifiedMessageModels.filter {$0.isPinned == false}
    }
    
    //MARK:- View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadJsonData()
        setupUI()
        setupConstraints()
        configureLongPressGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(topBar)
        view.addSubview(searchBar)
        
        //Configure & load collection view
        collectionView = createCollectionView()
        view.addSubview(collectionView)
        configureCollectionDataSource()
        //configiureCollectionLayoutList()
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let screenHeight = UIScreen.main.bounds.height
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            topBar.heightAnchor.constraint(
                equalToConstant: (((44/667 * screenHeight) < 44.0) ? 44.0 : (44/667 * screenHeight))),
            
            searchBar.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant:(Constants.edgeInset-5)),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant:-(Constants.edgeInset-5)),
            searchBar.heightAnchor.constraint(equalToConstant: 44.0),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func loadJsonData() {
        do {
            if let bundlePath = Bundle.main.path(forResource: "Sample_Response", ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(MessageModels.self, from: jsonData) {
                    originalMessageModels = decodedData
                }
            }
        } catch {
            print(error)
        }
    }
    
    var longPressGesture: UILongPressGestureRecognizer!
    private func configureLongPressGesture() {
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
}

//MARK:- SearchBarDelegate
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

//MARK:- CollectionView setup
extension MessagesViewController {
    
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
        
        let snapshot = { () -> NSDiffableDataSourceSnapshot<CollectionCellType, MessageModel> in
            var snapshot = NSDiffableDataSourceSnapshot<CollectionCellType, MessageModel>()
            snapshot.appendSections([CollectionCellType.pinnedCell, CollectionCellType.unPinnedCell])
            snapshot.appendItems(pinnedMessageModels, toSection: CollectionCellType.pinnedCell)
            snapshot.appendItems(unPinnedMessageModels, toSection: CollectionCellType.unPinnedCell)
            
            return snapshot
        }()
        
        collectionViewDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    //MARK: Collection Cell Layouts
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
        
        let unPinnedItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(100.0)
            )
        )
        unPinnedItem.contentInsets = cellItemEdgeInsets
        
        let unPinnedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(100.0)),
            subitems: [unPinnedItem]
        )
        
        let unPinnedSection = NSCollectionLayoutSection(group: unPinnedGroup)
        /*var configuration = UICollectionLayoutListConfiguration(appearance: unPinnedGroup)
        configuration.trailingSwipeActionsConfigurationProvider = {[unowned self] indexPath in

            let selectedItem = self.collectionViewDataSource.itemIdentifier(for: indexPath)
            return self.deleteItemOnSwipe(item: selectedItem!)

        }
        
        let unPinnedSection = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
*/
        
        return unPinnedSection
    }
    
    private func deleteItemOnSwipe(item: MessageModel) -> UISwipeActionsConfiguration? {
            
            let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: {[unowned self] action, view, completion in
                
                completion(true)
                
                let filteredIndices = modifiedMessageModels.indices.filter{modifiedMessageModels[$0] == item}
                modifiedMessageModels.remove(at: filteredIndices[0])
                reloadCollectionView()
            })
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .red
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
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
}

//MARK:- CollectionView Delegates

extension MessagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK:- Added Targets
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

//MARK:- TopBarView Delegate
extension MessagesViewController: TopBarViewDelegate {
    func editButtonTapped() {
        originalMessageModels.allInEditMode = true
        reloadCollectionView()
    }
    
    func doneButtonTapped() {
        originalMessageModels.allInEditMode = false
        reloadCollectionView()
    }
    
}

//MARK:- TopBarView Delegate
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
