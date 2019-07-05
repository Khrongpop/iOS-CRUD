//
//  Article.swift
//  iOS-CRUD
//
//  Created by Muang on 5/7/2562 BE.
//  Copyright © 2562 khrongpop. All rights reserved.
//

import Foundation
struct Article: Codable {
    var id : Int
    var title : String
    var detail : String
    var image : String?
    var created_at : String
}
