//
//  CollectionViewCell.swift
//  PocketTagsAddDemo
//
//  Created by Prateek Sharma on 14/01/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    
    func setCellUI(withText text: String, selected : Bool){
        
        textLabel.text = text
            
        if selected {
            backgroundColor = UIColor.green
        }
        else{
            backgroundColor = UIColor.lightGray
        }
        
    }
    
}
