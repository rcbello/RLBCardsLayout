//
//  ViewController.swift
//  RLBCardsLayoutDemo
//
//  Created by Riadh Luke Bello on 14/02/2017.
//  Copyright © 2017 Riadh Luke Bello. All rights reserved.
//

import UIKit



class ViewController: UICollectionViewController {
    
    private var observer: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make collection view to start from bottom
        observer = collectionView?.observe(\.contentSize, options:.old , changeHandler: { [unowned self] (collectionView, change) in
            guard let oldValue = change.oldValue,
            collectionView.contentSize != oldValue else { return }
            collectionView.contentOffset.y = collectionView.contentSize.height - collectionView.frame.height
            
            //assumes contentSize changes only once
            self.observer?.invalidate()
        })
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let row = collectionView.numberOfItems(inSection: indexPath.section) - indexPath.row
        
        let color = UIColor(red: CGFloat(25*row)/255.0, green: CGFloat((row % 3)*50)/255.0, blue: CGFloat((row % 5)*50)/255.0, alpha: 1)
        
        cell.viewWithTag(1000)?.backgroundColor = color
        
        (cell.viewWithTag(1001) as? UILabel)?.text = String(row)
        
        return cell
    }
    
    deinit {
        observer?.invalidate()
    }
}

