//
//  ContactHelper.swift
//  Tagger
//
//  Created by Aman Taneja on 23/04/18.
//  Copyright © 2018 Aman Taneja. All rights reserved.
//

import UIKit

class ContactHelper: NSObject {

    var contacts = [Contact]()
    
    override init() {
        let saurabh = Contact(name: "Saurabh Kumar", id: "", contactImage: UIImage(named: "Saurabh Kumar.jpg")!)
        contacts.append(saurabh)
        let vishal = Contact(name: "Vishal Assija", id: "", contactImage:UIImage(named: "Vishal Assija.jpg")!)
        contacts.append(vishal)
        let chetan = Contact(name: "Chetan Aggarwal", id: "", contactImage: UIImage(named: "Chetan Aggarwal.jpg")!)
        contacts.append(chetan)
        let umar = Contact(name: "Umar Farooque", id: "", contactImage: UIImage(named: "Umar Farooque.jpg")!)
        contacts.append(umar)
        let japneet = Contact(name: "Japneet Singh Chawla", id: "", contactImage: #imageLiteral(resourceName: "Japneet Singh Chawla.jpg"))
        contacts.append(japneet)
        let hemant = Contact(name: "Hemant Sardana", id: "", contactImage: #imageLiteral(resourceName: "Hemant Sardana.jpg"))
        contacts.append(hemant)
        let aakriti = Contact(name: "Aakriti Rampal", id: "", contactImage: #imageLiteral(resourceName: "Aakriti Rampal.jpg"))
        contacts.append(aakriti)
        let musarrat = Contact(name: "Musarrat Ahmed", id: "", contactImage: #imageLiteral(resourceName: "Musarrat Ahmed.jpg"))
        contacts.append(musarrat)
        let saloni = Contact(name: "Saloni Kathuria", id: "", contactImage:#imageLiteral(resourceName: "Saloni Kathuria.png"))
        contacts.append(saloni)
        let ashish = Contact(name: "Ashish Jain", id: "", contactImage:#imageLiteral(resourceName: "Ashish Jain.jpg"))
        contacts.append(ashish)
        
    }
    
    public func contactForContactName(name: String) -> Contact {
        return contacts.filter({$0.name! == name}).first!
    }
    
    public func allContactsForFilterText(name: String) -> [Contact] {
        return contacts.filter({$0.name!.localizedCaseInsensitiveContains(name)})
    }
}
