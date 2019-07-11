//
//  CustomBorder.swift
//  iOS-CRUD
//
//  Created by Muang on 11/7/2562 BE.
//  Copyright © 2562 khrongpop. All rights reserved.
//

import UIKit

class CustomBorder: UIButton {

    @IBInspectable var borderRadius: CGFloat = 0
    
    override func awakeFromNib() {
//      self.layer.borderWidth = 1
        self.layer.cornerRadius  = borderRadius
    }

}
