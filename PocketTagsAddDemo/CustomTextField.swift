//
//  CustomTextField.swift
//  PocketTagsAddDemo
//
//  Created by Prateek Sharma on 15/01/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

@objc protocol DeleteActionProtocol {
    @objc optional func deleteAction()
}

class CustomTextField: UITextField {

    var deleteDelegate : DeleteActionProtocol?
    
    override func deleteBackward() {
        
        if self.text == "" {
        
            if deleteDelegate != nil {
                deleteDelegate?.deleteAction?()
            }
            
        }
        
        super.deleteBackward()
        
    }
    
}
