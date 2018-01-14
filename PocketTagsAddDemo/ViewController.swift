//
//  ViewController.swift
//  PocketTagsAddDemo
//
//  Created by Prateek Sharma on 14/01/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionViewContraint: NSLayoutConstraint!
    
    var inputFieldCell : InputCollectionViewCell! = nil
    var enteredTags = [String]()

    var selectedInd : Int! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.collectionViewLayout = UICollectionViewLeftAlignedLayout()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegateLeftAlignedLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return enteredTags.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == enteredTags.count {
            if inputFieldCell == nil {
                inputFieldCell = collectionView.dequeueReusableCell(withReuseIdentifier: "inputCell", for: indexPath) as! InputCollectionViewCell
                inputFieldCell.textField.delegate = self
            }
            return inputFieldCell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            
            var isSelected = false
            
            if selectedInd != nil {
                if selectedInd == indexPath.row {
                    isSelected = true
                }
            }
            
            cell.setCellUI(withText: enteredTags[indexPath.row], selected: isSelected)
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == enteredTags.count {
            
        }
        else{
            
        }
        return CGSize.zero
    }
    
    private func estimatedFrameForText(_ text : String) -> CGRect{
        let size = CGSize(width: self.collectionView.frame.width - 15, height: 1000)
        return NSString(string: text).boundingRect(with: size, options: [NSStringDrawingOptions.usesLineFragmentOrigin , .usesFontLeading], attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica", size: 16)!], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 7, bottom: 4, right: 7)
    }
    
}

extension ViewController : UITextFieldDelegate {
    
    
}

