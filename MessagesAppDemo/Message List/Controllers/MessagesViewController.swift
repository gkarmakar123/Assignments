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

        return theSearchBar
    }()
    
    //MARK:- CollectionView Properties
    var collectionView: UICollectionView!
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<CollectionCellType, MessageModel>! = nil
    
    //Data Model Objects
    var mainMessageModel: MessageMainModel!
    
    var longPressGesture: UILongPressGestureRecognizer!
    
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
    
    //MARK:- Setup
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
                
                if let decodedData = try? decoder.decode(MessageMainModel.self, from: jsonData) {
                    mainMessageModel = decodedData
                }
            }
        } catch {
            print(error)
        }
    }
    
    func configureLongPressGesture() {
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
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
