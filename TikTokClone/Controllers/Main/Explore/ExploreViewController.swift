//
//  ExploreViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import UIKit


class ExploreViewController: UIViewController {
    
    // MARK: Attributes
    
    private var sections = [ExploreSectionModel]()
    
    private var collectionView: UICollectionView?
    
    private var exploreLayout = ExploreLayoutCollectionView.shared
    
    // MARK: UI Elements
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search TikTok..."
        bar.layer.cornerRadius = 10
        bar.layer.masksToBounds = true
        return bar
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureModels()
        
        setUpSearchbar()
        
        setUpCollectionView()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setFrames()
    }
    
    
    // MARK: Functions
    
    private func setFrames() {
        
        collectionView?.frame = view.bounds
        
    }
    
    private func setUpSearchbar() {
        
        navigationItem.titleView = searchBar
        
        searchBar.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditingOnTap))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
    }
    
    // explore sections setup
    private func setUpCollectionView() {
        
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            
            return self.layout(for: section)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(ExplorePostCollectionViewCell.self, forCellWithReuseIdentifier: ExplorePostCollectionViewCell.identifier)
        collectionView.register(ExploreHashtagCollectionViewCell.self, forCellWithReuseIdentifier: ExploreHashtagCollectionViewCell.identifier)
        collectionView.register(ExploreFeaturedCollectionViewCell.self, forCellWithReuseIdentifier: ExploreFeaturedCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
        
        // collection view styling
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
    }
    
    // collection view layout setup
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        
        // find section type
        let sectionType = sections[section].type
        
        switch sectionType {
            
        case .featured:
            return exploreLayout.getFeaturedLayout()
        case .creators:
            return exploreLayout.getCreatorsLayout()
        case .hashtags:
            return exploreLayout.getHashtagLayout()
        case .recommended:
            return exploreLayout.getRecommendedLayout()
        case .recent:
            return exploreLayout.getFeaturedLayout()
        }
        
    }
    
    private func configureModels() {
        
        var cellsFeatured = [ExploreCell]()
        var cellsPost = [ExploreCell]()
        var cellsHashtags = [ExploreCell]()
        
        for _ in 0...10 {
            
            // add mock data
            let cellFeatured = ExploreCell.featured(viewModel: ExploreFeaturedViewModel(image: UIImage(named: "test"), title: "Title", handler: {}))
            let cellPost = ExploreCell.post(viewModel: ExplorePostViewModel(caption: "Awesome!!", image: UIImage(named: "test"), handler: {}))
            let cellHashtag = ExploreCell.hashtags(viewModel: ExploreHashtagViewModel(text: "#love", icon: UIImage(systemName: "heart.fill"), count: 2, handler: {}))
            
            // append
            cellsFeatured.append(cellFeatured)
            cellsPost.append(cellPost)
            cellsHashtags.append(cellHashtag)
        }
        
        // Featured
        sections.append(ExploreSectionModel(type: .featured, cells: cellsFeatured))
        
        // Creators
        sections.append(ExploreSectionModel(type: .creators, cells: cellsPost))
        
        // Hashtags
        sections.append(ExploreSectionModel(type: .hashtags, cells: cellsHashtags))
        
        // Recommended
        sections.append(ExploreSectionModel(type: .recommended, cells: cellsPost))
        
        // Recent
        sections.append(ExploreSectionModel(type: .recent, cells: cellsFeatured))
        
    }
    
    // end editing on tap anywhere on the screen
    
    @objc
    private func endEditingOnTap() {
        
        searchBar.endEditing(true)
        
    }
    
    
}

// MARK: UISearchBarDelegate

extension ExploreViewController: UISearchBarDelegate {
    
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // selection of item in collection view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        
    }
    
    // number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    // number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    // configuring each cell on a collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
            
        case .featured(viewModel: let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreFeaturedCollectionViewCell.identifier, for: indexPath) as? ExploreFeaturedCollectionViewCell else {
                
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                
            }
            
            cell.configure(with: viewModel)
            
            return cell
            
        case .hashtags(viewModel: let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreHashtagCollectionViewCell.identifier, for: indexPath) as? ExploreHashtagCollectionViewCell else {
                
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                
            }
            
            cell.configure(with: viewModel)
            
            cell.layer.cornerRadius = 10
            cell.layer.borderColor = UIColor.label.cgColor
            cell.layer.borderWidth = 1
            
            return cell
            
        case .post(viewModel: let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExplorePostCollectionViewCell.identifier, for: indexPath) as? ExplorePostCollectionViewCell else {
                
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                
            }
            
            cell.configure(with: viewModel)
            
            return cell
        }
    
    }
    
    
}
