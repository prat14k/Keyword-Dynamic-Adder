//
//  CollectionViewCell.swift
//  PocketTagsAddDemo
//
//  Created by Prateek Sharma on 14/01/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    let selectedColor = UIColor(red: 44.0/255.0, green: 167.0/255.0, blue: 158.0/255.0, alpha: 1.0)
    let unSelectedColor = UIColor.lightGray

    @IBOutlet weak var textLabel: UILabel!
    
    func setCellUI(withText text: String, selected : Bool){
        
        textLabel.text = text
            
        if selected {
            becomeFirstResponder()
            backgroundColor = selectedColor
        }
        else{
            resignFirstResponder()
            backgroundColor = unSelectedColor
        }
        
    }
    
}
