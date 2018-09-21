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
        let saurabh = Contact(name: "Saurabh Kumar", id: "", contactImage: UIImage(named: "Send")!)
        contacts.append(saurabh)
        let vishal = Contact(name: "Vishal Assija", id: "", contactImage:UIImage(named: "Send")!)
        contacts.append(vishal)
        let chetan = Contact(name: "Chetan Aggarwal", id: "", contactImage: UIImage(named: "Send")!)
        contacts.append(chetan)
        let umar = Contact(name: "Umar Farooque", id: "", contactImage: UIImage(named: "Send")!)
        contacts.append(umar)
        let japneet = Contact(name: "Japneet Singh Chawla", id: "", contactImage: UIImage(named: "Send")!)
        contacts.append(japneet)
        let hemant = Contact(name: "Hemant Sardana", id: "", contactImage: UIImage(named: "Send")!)
        contacts.append(hemant)
        let aakriti = Contact(name: "Aakriti Rampal", id: "", contactImage: UIImage(named: "Send")!)
        contacts.append(aakriti)
        let musarrat = Contact(name: "Musarrat Ahmed", id: "", contactImage: UIImage(named: "Send")!)
        contacts.append(musarrat)
        let saloni = Contact(name: "Saloni Kathuria", id: "", contactImage:UIImage(named: "Send")!)
        contacts.append(saloni)
        let ashish = Contact(name: "Ashish Jain", id: "", contactImage:UIImage(named: "Send")!)
        contacts.append(ashish)
        
    }
    
    public func contactForContactName(name: String) -> Contact {
        return contacts.filter({$0.name! == name}).first!
    }
    
    public func allContactsForFilterText(name: String) -> [Contact] {
        return contacts.filter({$0.name!.localizedCaseInsensitiveContains(name)})
    }
}
