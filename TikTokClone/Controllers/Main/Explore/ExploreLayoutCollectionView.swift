//
//  ExploreLayoutCollectionView.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/14/22.
//
// class for easier workflow and fewer code per file

import UIKit

// configuring layouts of each section in whole collection view
class ExploreLayoutCollectionView: UICollectionViewController {
    
    // MARK: Attributes

    static let shared = ExploreLayoutCollectionView()

    // MARK: Functions
    
    /// Explore sections
    
    /// FEATURED
    
    func getFeaturedLayout() -> NSCollectionLayoutSection {
        
        //create section layout
        // item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        // group
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.9),
                heightDimension: .absolute(200)),
            subitems: [item])
        
        
        // section layout
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        
        // return
        return section
    }
    
    /// CREATORS
    
    func getCreatorsLayout() -> NSCollectionLayoutSection {
        
        //create section layout
        // item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        // group
        let groupVertical = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(100),
                heightDimension: .absolute(200)),
            subitem: item,
            count: 2)
        
        let groupHorizontal = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(105),
                heightDimension: .absolute(200)),
            subitems: [groupVertical])
        
        // section layout
        let section = NSCollectionLayoutSection(group: groupHorizontal)
        section.orthogonalScrollingBehavior = .continuous
        
        
        // return
        return section
    }
    
    
    /// HASHTAGS
    
    func getHashtagLayout() -> NSCollectionLayoutSection {
        //create section layout
        // item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        // group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.25),
                heightDimension: .absolute(50)),
            subitems: [item])
        
        // section layout
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        
        // return
        return section
    }
    
    
    /// RECOMMENDED
    
    func getRecommendedLayout() -> NSCollectionLayoutSection {
        
        //create section layout
        // item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        // group
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(200),
                heightDimension: .absolute(200)),
            subitems: [item])
        
        
        // section layout
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        
        // return
        return section
    }

    /// RECENT SECTION USES THE SAME LAYOUT AS FEATURED
}
