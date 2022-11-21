//
//  ExploreViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import UIKit


class ExploreViewController: UIViewController {
    
    // MARK: Attributes
    
    private lazy var sections = [ExploreSectionModel]()
    
    private var collectionView: UICollectionView?
    
    private lazy var exploreLayout = ExploreLayoutCollectionView.shared
    
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
        
        ExploreManager.shared.delegate = self
        
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
        
        collectionView.register(ExploreUserCollectionViewCell.self, forCellWithReuseIdentifier: ExploreUserCollectionViewCell.identifier)
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
        
        // Featured
        sections.append(ExploreSectionModel(type: .featured, cells: ExploreManager.shared.getExploreFeatured().compactMap({ viewModel in
            return ExploreCell.featured(viewModel: viewModel)
        })))
        
        // Creators
        sections.append(ExploreSectionModel(type: .creators, cells: ExploreManager.shared.getExploreCreators().compactMap({ viewModel in
            return ExploreCell.user(viewModel: viewModel)
        })))
        
        // Hashtags
        sections.append(ExploreSectionModel(type: .hashtags, cells: ExploreManager.shared.getExploreHashtags().compactMap({ viewModel in
            return ExploreCell.hashtags(viewModel: viewModel)
        })))
        
        // Recommended
        sections.append(ExploreSectionModel(type: .recommended, cells: ExploreManager.shared.getExploreRecommended().compactMap({ viewModel in
            return ExploreCell.user(viewModel: viewModel)
        })))
        
        // Recent
        sections.append(ExploreSectionModel(type: .recent, cells: ExploreManager.shared.getExploreRecent().compactMap({ viewModel in
            return ExploreCell.featured(viewModel: viewModel)
        })))
        
    }
    
    // end editing on tap anywhere on the screen
    
    @objc
    private func endEditingOnTap() {
        
        searchBar.endEditing(true)
        
    }
    
    
}

// MARK: UISearchBarDelegate

extension ExploreViewController: UISearchBarDelegate {
    
    // user begins to type in the search bar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        // add cancel button to reset search bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
        
    }
    
    // reseting search bar
    @objc private func didTapCancel() {
        
        navigationItem.rightBarButtonItem = nil
        
        searchBar.text = nil
        searchBar.resignFirstResponder()
        
    }
    
    // when user press search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
    }
    
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // selection of item in collection view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
            
        case .featured(viewModel: let viewModel):
            viewModel.handler()
            
        case .hashtags(viewModel: let viewModel):
            viewModel.handler()
            
        case .user(viewModel: let viewModel):
            viewModel.handler()
            
        }
        
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
            
            
        case .user(viewModel: let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreUserCollectionViewCell.identifier, for: indexPath) as? ExploreUserCollectionViewCell else {
                
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                
            }
            
            cell.configure(with: viewModel)
            
            return cell
        }
        
    }
    
    
}

// MARK: ExploreManagerDelegate

// pushing vc for depending on the selected row in section
extension ExploreViewController: ExploreManagerDelegate {
    
    func pushViewController(vc: UIViewController) {
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
