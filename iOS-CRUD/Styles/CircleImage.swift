//
//  CircleImage.swift
//  iOS-CRUD
//
//  Created by Muang on 11/7/2562 BE.
//  Copyright © 2562 khrongpop. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.width / 2
    }

}
