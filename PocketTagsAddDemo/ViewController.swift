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
//    var lastTagCell : CollectionViewCell! = nil
    
    var presentXposition : CGFloat! = 4
    
    var enteredTags = [String]()

    var selectedInd : Int! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.collectionViewLayout = UICollectionViewLeftAlignedLayout()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setCollectionViewHght()
    }
    
    func setCollectionViewHght(){
        
        heightCollectionViewContraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
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
            
//            if indexPath.row == ( enteredTags.count - 1 ) {
//                lastTagCell = cell
//            }
            
            cell.setCellUI(withText: enteredTags[indexPath.row], selected: isSelected)
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == enteredTags.count {
            var width = self.collectionView.frame.width - 4
            
//            if(lastTagCell != nil) {
//                let remainingWidth = width - (lastTagCell.frame.origin.x + 3)
//                if remainingWidth >= 60 {
//                    width = remainingWidth
//                }
//            }

            if presentXposition != 4 {
                if (width - (presentXposition + 3)) > 60 {
                    width = width - (presentXposition + 4)
                }
            }
            
            presentXposition = 4
            return CGSize(width: width, height: 32)
        }
        else{
            var calculatedSize = estimatedFrameForText(enteredTags[indexPath.row]).size
            var height : CGFloat
            if calculatedSize.height < 25 {
                height = 32
            }
            else{
                height = calculatedSize.height + 8
                calculatedSize.width = collectionView.frame.size.width - 14 - 8
            }
            
            if presentXposition != 4 {
                presentXposition = presentXposition + 4
            }
            presentXposition = presentXposition + calculatedSize.width + 14
            if presentXposition > (collectionView.frame.size.width - 4) {
                presentXposition = 4 + calculatedSize.width + 14
            }
            
            return CGSize(width: calculatedSize.width + 14, height: height)
        }
    }
    
    private func estimatedFrameForText(_ text : String) -> CGRect{
        let size = CGSize(width: self.collectionView.frame.width - 8, height: 1000)
        return NSString(string: text).boundingRect(with: size, options: [NSStringDrawingOptions.usesLineFragmentOrigin , .usesFontLeading], attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica", size: 16)!], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text , text != "" {
            enteredTags.append(text)
            
            collectionView.reloadData()
            
            setCollectionViewHght()
            
            textField.text = ""
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            if (textField.text?.count)! >= 25 {
                return false
            }
        }
        return true
    }
}

