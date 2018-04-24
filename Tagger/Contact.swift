//
//  Contact.swift
//  Tagger
//
//  Created by Aman Taneja on 23/04/18.
//  Copyright © 2018 Aman Taneja. All rights reserved.
//

import UIKit

class Contact: NSObject {

    var name: String?
    var id: String?
    var contactImage: UIImage?
 
    init(name: String, id: String, contactImage: UIImage) {
        self.name = name
        self.id = id
        self.contactImage = contactImage
    }

}
