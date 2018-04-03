//
//  Category.swift
//  TodoList
//
//  Created by mehdi dridi on 4/2/18.
//  Copyright © 2018 mehdi dridi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
   @objc dynamic var name : String = ""
   @objc dynamic var color : String = ""
    let items = List<Item>()
}
