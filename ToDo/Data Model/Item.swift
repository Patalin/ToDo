//
//  Item.swift
//  ToDo
//
//  Created by Patalin on 29/10/2019.
//  Copyright © 2019 Patalin. All rights reserved.
//

import Foundation
import RealmSwift


class Item : Object {
    
   @objc dynamic var title : String = ""
   @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
