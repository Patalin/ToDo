//
//  Category.swift
//  ToDo
//
//  Created by Patalin on 29/10/2019.
//  Copyright © 2019 Patalin. All rights reserved.
//

import Foundation
import RealmSwift


class Category : Object {
    
   @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    let items = List<Item>()
    
}
