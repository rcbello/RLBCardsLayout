//
//  ViewController.swift
//  RLBCardsLayoutDemo
//
//  Created by Riadh Luke Bello on 14/02/2017.
//  Copyright © 2017 Riadh Luke Bello. All rights reserved.
//

import UIKit



class ViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let color = UIColor(red: CGFloat(25*indexPath.row)/255.0, green: CGFloat((indexPath.row % 3)*50)/255.0, blue: CGFloat((indexPath.row % 5)*50)/255.0, alpha: 1)
        
        cell.viewWithTag(1000)?.backgroundColor = color
        
        (cell.viewWithTag(1001) as? UILabel)?.text = String(indexPath.row + 1)
        
        return cell
    }
    
    
}

