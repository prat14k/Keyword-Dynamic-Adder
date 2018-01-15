//
//  ViewController.swift
//  PocketTagsAddDemo
//
//  Created by Prateek Sharma on 14/01/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

let collectionViewBorderSpace : CGFloat = 7
let collectionViewRowMidSpace : CGFloat = 5
let collectionViewRowsSpace : CGFloat = 5

class ViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionViewContraint: NSLayoutConstraint!
    
    var inputFieldCell : InputCollectionViewCell! = nil
//    var lastTagCell : CollectionViewCell! = nil
    
    var presentXposition : CGFloat! = collectionViewBorderSpace
    
    var enteredTags = [String]()

    var selectedInd : Int! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.collectionViewLayout = UICollectionViewLeftAlignedLayout()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        heightCollectionViewContraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func closeKeyboard(){
        inputFieldCell.textField.resignFirstResponder()
    }
    
    func setCollectionViewHght(){
        
        heightCollectionViewContraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func selectTagCell(atIndex index : Int!){
        
        var indexPathsArr = [IndexPath]()
        
        if index != nil {
            if index < enteredTags.count {
                if selectedInd != nil {
                    if index == selectedInd {
                        return
                    }
                    indexPathsArr.append(IndexPath(item: selectedInd, section: 0))
                    selectedInd = nil
                }
                
                inputFieldCell.textField.tintColor = UIColor.clear
                
                selectedInd = index
                indexPathsArr.append(IndexPath(item: selectedInd, section: 0))
            }
        }
        else if selectedInd != nil {
            indexPathsArr.append(IndexPath(item: selectedInd, section: 0))
            selectedInd = nil
        }
        
        if indexPathsArr.count > 0 {
            collectionView.reloadItems(at: indexPathsArr)
        }
    }
    
    @objc func textFieldTapped(_ gesture : UIGestureRecognizer){
        inputFieldCell.textField.tintColor = UIColor.green
        inputFieldCell.textField.becomeFirstResponder()
        selectTagCell(atIndex: nil)
    }
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegateLeftAlignedLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < enteredTags.count {
            inputFieldCell.textField.text = ""
            selectTagCell(atIndex: indexPath.row)
        }
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
                inputFieldCell.textField.deleteDelegate = self
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldTapped(_:)))
                tapGesture.numberOfTapsRequired = 1
                inputFieldCell.textField.addGestureRecognizer(tapGesture)
                
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
            var width = self.collectionView.frame.width - (collectionViewBorderSpace * 2)
        
            if presentXposition != collectionViewBorderSpace {
                if (width - (presentXposition + collectionViewRowMidSpace - collectionViewBorderSpace)) > 80 {
                    width = width - (presentXposition - collectionViewBorderSpace + collectionViewRowMidSpace)
                }
            }
            
            presentXposition = collectionViewBorderSpace
            return CGSize(width: width, height: 28)
        }
        else{
            var calculatedSize = estimatedFrameForText(enteredTags[indexPath.row]).size
            var height : CGFloat
            if calculatedSize.height < 25 {
                height = 28
            }
            else{
                // The Label has a 4 + 4 Vertical Padding and a 6 + 6 Horizontal Padding (7+7 is to provide a bit extra space)
                height = calculatedSize.height + 8
                calculatedSize.width = collectionView.frame.size.width - 14 - 8
            }
            
            if presentXposition != collectionViewBorderSpace {
                presentXposition = presentXposition + collectionViewRowMidSpace
            }
            presentXposition = presentXposition + calculatedSize.width + 14
            if presentXposition > (collectionView.frame.size.width - collectionViewBorderSpace) {
                presentXposition = collectionViewBorderSpace + calculatedSize.width + 14
            }
            
            return CGSize(width: calculatedSize.width + 14, height: height)
        }
    }
    
    private func estimatedFrameForText(_ text : String) -> CGRect{
        let size = CGSize(width: (self.collectionView.frame.width - (collectionViewBorderSpace * 2)), height: 1000)
        return NSString(string: text).boundingRect(with: size, options: [NSStringDrawingOptions.usesLineFragmentOrigin , .usesFontLeading], attributes: [NSAttributedStringKey.font : UIFont(name: "Helvetica", size: 15)!], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewBorderSpace, left: collectionViewBorderSpace, bottom: collectionViewBorderSpace, right: collectionViewBorderSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewRowsSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewRowMidSpace
    }
}

extension ViewController : UITextFieldDelegate , DeleteActionProtocol {
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text , text != "" {
            enteredTags.append(text)
            
//            collectionView.reloadData()
            
            collectionView.insertItems(at: [IndexPath(item: enteredTags.count-1, section: 0)])
//            collectionView.reloadItems(at: [IndexPath(item: enteredTags.count, section: 0)])
            
            setCollectionViewHght()
            
            textField.text = ""
        }
        else{
            textField.resignFirstResponder()
        }
        
        if selectedInd != nil {
            selectTagCell(atIndex: nil)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            textField.tintColor = UIColor.green
            if (textField.text?.count)! >= 50 {
                return false
            }
            
            if selectedInd != nil && enteredTags.count > 0 {
                enteredTags.remove(at: selectedInd)
                let ind = selectedInd
                selectedInd = nil
                collectionView.deleteItems(at: [IndexPath(item: ind!, section: 0)])
                setCollectionViewHght()
            }
        }
        
        return true
    }
    
    func deleteAction() {
        if selectedInd != nil && enteredTags.count > 0 {
            enteredTags.remove(at: selectedInd)
            let ind = selectedInd
            selectedInd = nil
            collectionView.deleteItems(at: [IndexPath(item: ind!, section: 0)])
            setCollectionViewHght()
            inputFieldCell.textField.tintColor = UIColor.green
            return
        }
        
        if enteredTags.count > 0 {
            selectTagCell(atIndex: enteredTags.count - 1)
        }
    }
    
}

