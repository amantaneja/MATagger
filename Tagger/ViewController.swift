//
//  ViewController.swift
//  Tagger
//
//  Created by Aman Taneja on 11/04/18.
//  Copyright © 2018 Aman Taneja. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bottomTextViewConstraint     : NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint    : NSLayoutConstraint!
    @IBOutlet weak var postButtonBottomConstraint   : NSLayoutConstraint!
    @IBOutlet weak var commentViewTop               : NSLayoutConstraint!
    
    @IBOutlet weak var commentsTableView        : UITableView!
    @IBOutlet weak var autoCompleteTableView    : UITableView!
    @IBOutlet weak var textView                 : UITextView!
    @IBOutlet weak var postButton               : UIButton!
    
    @IBOutlet var parentView                    : UIView!
    @IBOutlet weak var commentView              : UIView!
    
    @IBOutlet var imageTaggs: [UIImageView]!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    let helper = ContactHelper()
    
    var taggedContacts = [String]()
    var filteredContacts = [Contact]()
    
    var isTagging: Bool = false
    var isUpdated: Bool = false
    
    var filterTextString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupShadow()
        setupTableView()
        setupCommentView()
        setupImageTags()
        
        commentView.isHidden = true
        
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.view.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
    }
    
    func setupImageTags() {
        for image in imageTaggs {
            image.layer.cornerRadius = 12
            image.layer.masksToBounds = true
            image.clipsToBounds = true
            image.layer.borderWidth = 1.5
            image.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @objc func dismissKeyboard(){
        self.textView.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector:#selector(ViewController.keyboardDidAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(ViewController.keyboardWillDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setupView() {
        parentView.layer.cornerRadius = 19.5
        parentView.clipsToBounds = true
        parentView.layer.masksToBounds = true
        
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        
        commentLabel.attributedText = textView.attributedText
        textView.text = " "
        self.commentView.isHidden = false

        UIView.animate(withDuration: 0.7) {
            self.commentViewTop.constant = 12
            self.view.layoutIfNeeded()
        }
    }
    
    func setupTableView() {
        autoCompleteTableView.isHidden = true
        autoCompleteTableView.tableFooterView = UIView()
        autoCompleteTableView.layer.cornerRadius = 8.0
        
        autoCompleteTableView.delegate = self
        autoCompleteTableView.dataSource = self
        
//        commentsTableView.delegate = self
//        commentsTableView.dataSource = self
    }
    
    func setupCommentView() {
        self.commentView.layer.cornerRadius = 8.0
        self.commentView.layer.masksToBounds = true
        self.commentView.clipsToBounds = true
        
        self.commentView.layer.shadowOpacity = 0.18
        self.commentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.commentView.layer.shadowRadius = 0
        self.commentView.layer.shadowColor = UIColor.black.cgColor
        self.commentView.layer.masksToBounds = false
        
    }
    
    func setupShadow(){
        
        self.parentView.layer.shadowOpacity = 0.18
        self.parentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.parentView.layer.shadowRadius = 0
        self.parentView.layer.shadowColor = UIColor.black.cgColor
        self.parentView.layer.masksToBounds = false
        
        self.postButton.layer.shadowOpacity = 0.18
        self.postButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.postButton.layer.shadowRadius = 0
        self.postButton.layer.shadowColor = UIColor.black.cgColor
        self.postButton.layer.masksToBounds = false
        
    }
}

extension ViewController {
    
    @objc func keyboardDidAppear(_ notification: Notification) {
        var info = notification.userInfo!
        let keyboardFrame  = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        self.bottomTextViewConstraint.constant = keyboardFrame.height+5
        postButtonBottomConstraint.constant = keyboardFrame.height+5
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        self.bottomTextViewConstraint.constant = 2
        postButtonBottomConstraint.constant = 10
    }
}

extension ViewController : UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let selectedRange = textView.selectedTextRange {
            
            let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
            
            setupLabel(cursorPosition: cursorPosition > 0 ? cursorPosition-1 : 0)
        }
    }
    
    func textViewLength(length:Int) {
        
        guard let position = Int(self.getCursorPosition()) else { return }
        let attributedText = ViewController.generateAttributedString(with: taggedContacts.last!, targetString: taggedContacts.last! + " ", isAutoComplete: false)
        
        let combination = NSMutableAttributedString()
        combination.append(textView.attributedText)
        combination.append(attributedText!)
        combination.replaceCharacters(in: NSRange(location: position-length, length: length), with: "")
        
        textView.attributedText = combination
        
    }
    
    func getCursorPosition () -> String {
        
        guard let selectedRange = textView.selectedTextRange else { return "" }
        let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
        return cursorPosition.description
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range.length > 1 && text == "" {
            textView.text = " "
            return false
        }
        
        if text == "" {
            if textView.text.count == 0 {
                return false
            }
            if let selectedRange = textView.selectedTextRange {
                let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
                
                
                
                let length = range.length-1
                self.setupBackspace(cursorPosition: cursorPosition > 0 ? cursorPosition-1 : 0 , length: length)
                
            }
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = " "
        }
    }
    
    func characterBeforeCursor() -> String? {
        
        if let cursorRange = textView.selectedTextRange {
            
            if let newPosition = textView.position(from: cursorRange.start, offset: -1) {
                
                let range = textView.textRange(from: newPosition, to: cursorRange.start)
                return textView.text(in: range!)
            }
        }
        return nil
    }
    
    func charactersBeforeCursor(length: Int, character: String = "@"){
        
        guard let cursorRange = textView.selectedTextRange else { return }
        guard let newPositon = textView.position(from: cursorRange.start, offset: -(length+1)) else { return }
        let range = textView.textRange(from: newPositon, to: cursorRange.start)
        if textView.text(in: range!)?.first?.description == character {
            textViewLength(length: length+1)
        } else {
            charactersBeforeCursor(length: length+1)
        }
    }
    
    func characterBeforeCursorForTagging(length: Int, character: String = "@") {
        guard let cursorRange = textView.selectedTextRange else { return }
        guard let newPositon = textView.position(from: cursorRange.start, offset: -(length+1)) else { return }
        let range = textView.textRange(from: newPositon, to: cursorRange.start)
        if textView.text(in: range!)?.first?.description == character {
            textViewLength1(length: length)
        } else {
            characterBeforeCursorForTagging(length: length+1)
        }
    }
    
    func textViewLength1(length: Int) {
        
        guard let position = Int(self.getCursorPosition()) else { return }
        
        let rangeOfString = NSRange(location: position-length-1, length: length)
        if let swiftRange = Range(rangeOfString, in: textView.text) {
            
            var dealSubString = textView.text[swiftRange.lowerBound...]
            _ = dealSubString.removeFirst()
            if ViewController.isValidString(String(dealSubString)) {
                manageTagging(textString: String(dealSubString))
            } else {
                autoCompleteTableView.isHidden = true
            }
        } else {
            autoCompleteTableView.isHidden = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        postButton.isEnabled = ViewController.isValidString(textView.text) ? true : false
        
        if textView.text == "" {
            textView.text.append("\u{00A0}")
        }
        
        if !isTagging{
            if self.characterBeforeCursor() == "@" {
                isTagging = true
                manageTagging(textString: "")
            }
        } else {
            characterBeforeCursorForTagging(length: 0)
        }
    }
    
    func manageTagging(textString: String) {
        
        self.autoCompleteTableView.isHidden = false
        
        if helper.allContactsForFilterText(name: textString).count != 0 {
            filteredContacts = helper.allContactsForFilterText(name: textString)
            UIView.animate(withDuration: 0.2, animations: {
                self.filterTextString = textString
                self.autoCompleteTableView.reloadData()
                self.tableViewHeightConstraint.constant = self.filteredContacts.count > 5 ? 220 : CGFloat(27+self.filteredContacts.count*44)
                self.autoCompleteTableView.layoutIfNeeded()
                self.autoCompleteTableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 25, right: 0)
            })
        } else {
            autoCompleteTableView.isHidden = true
        }
    }
}

extension ViewController {
    func setupLabel(cursorPosition: Int) {
        
        if textView.text.count == 1 {
            setCursor(cursorPosition: 0)
        }
        
        if cursorPosition < 0 {
            setCursor(cursorPosition: cursorPosition)
        }
        
        if cursorPosition < textView.text.count {
            let attr = textView.attributedText?.attributes(at: cursorPosition, longestEffectiveRange: nil, in: NSRange(location: 0, length: (textView.text?.count)!+1))
            
            if (attr?.count)! > 0 {
                
                if (attr?.keys.contains(NSAttributedStringKey.foregroundColor))! {
                    
                    for att in attr! {
                        if att.key == NSAttributedStringKey.foregroundColor {
                            if att.value as! UIColor == UIColor.systemBlue() {
                                isUpdated = true
                                setupLabel(cursorPosition: cursorPosition+1)
                                return
                            } else {
                                setCursor(cursorPosition: cursorPosition)
                                return
                            }
                        } else {
                            setCursor(cursorPosition: cursorPosition)
                            return
                        }
                    }
                } else {
                    setCursor(cursorPosition: cursorPosition)
                    return
                }
            } else {
                setCursor(cursorPosition: cursorPosition)
                return
            }
        }
    }
    
    func setupBackspace(cursorPosition: Int, length: Int) {
        
        if textView.text.count == 1 {
            return
        }
        
        if cursorPosition < 0 {
            removeText(length: length)
        }
        
        let attr = textView.attributedText?.attributes(at: cursorPosition > 0 ? cursorPosition-1 : 0, longestEffectiveRange: nil, in: NSRange(location: 0, length: (textView.text?.count)!+1))
        
        if (attr?.count)! > 0 {
            
            if (attr?.keys.contains(NSAttributedStringKey.foregroundColor))! {
                
                for att in attr! {
                    if att.key == NSAttributedStringKey.foregroundColor {
                        if att.value as! UIColor == UIColor.systemBlue() {
                            setupBackspace(cursorPosition: cursorPosition-1, length: length+1)
                            return
                        } else {
                            length > 0 ? removeText(length: length+1) : removeText(length: 0)
                            return
                        }
                    } else {
                        length > 0 ? removeText(length: length+1) : removeText(length: 0)
                        return
                    }
                }
            } else {
                length > 0 ? removeText(length: length+1) : removeText(length: 0)
                return
            }
        } else {
            length > 0 ? removeText(length: length+1) : removeText(length: 0)
            return
        }
        
    }
    
    func removeText(length: Int) {
        
        if let cursorRange = textView.selectedTextRange {
            
            // get the position one character before the cursor start position
            if let newPosition = textView.position(from: cursorRange.start, offset: -length) {
                
                let range = textView.textRange(from: newPosition, to: cursorRange.start)
                textView.replace(range!, withText: "")
            }
        }
    }
    
    func setCursor(cursorPosition: Int) {
        if isUpdated {
            let position = textView.position(from: textView.beginningOfDocument, offset: cursorPosition)!
            textView.selectedTextRange = textView.textRange(from: position, to: position)
        }
        
        isUpdated = false
    }
}


//Generate Attributed String
extension ViewController {
    class func generateAttributedString(with searchTerm: String, targetString: String, isAutoComplete:Bool) -> NSAttributedString? {
        
        let attributedString = NSMutableAttributedString(string: targetString)
        
        do {
            let regex = try NSRegularExpression(pattern: searchTerm.folding(options: .diacriticInsensitive, locale: .current), options: .caseInsensitive)
            let range = NSRange(location: 0, length: targetString.utf16.count)
            for match in regex.matches(in: targetString.folding(options: .diacriticInsensitive, locale: .current), options: .withTransparentBounds, range: range) {
                if isAutoComplete {
                    attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 13) , range: match.range)
                } else {
                    attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.systemBlue() , range: match.range)
                    attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 13) , range: match.range)
                }
            }
            return attributedString
            
        } catch {
            let _ = NSRange(location: 0, length: targetString.utf16.count)
            return attributedString
        }
    }
}

//Helpers
extension ViewController {
    class func isValidString(_ string: String?) -> Bool {
        if string != nil && !string!.isEmpty && string != "" && string != "<null>" && string != "NULL" {
            return true
        }
        else {
            return false
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutocompleteCell", for: indexPath)
        let contactData = filteredContacts[indexPath.row]
        
        if let imageView = cell.viewWithTag(10) as? UIImageView {
            
            imageView.layer.cornerRadius = imageView.layer.frame.height/2
            imageView.clipsToBounds = true
            imageView.layer.masksToBounds = true
            
            imageView.image = contactData.contactImage
        }
        
        if let nameLabel = cell.viewWithTag(11) as? UILabel {
            nameLabel.attributedText = ViewController.generateAttributedString(with: filterTextString, targetString: contactData.name!, isAutoComplete: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == autoCompleteTableView{
            
            taggedContacts.append(filteredContacts[indexPath.row].name!)
            charactersBeforeCursor(length: 0)
            
            self.autoCompleteTableView.isHidden = true
            self.isTagging = false
        }
    }
    
}
extension UIColor {
    class func systemBlue() -> UIColor {
        return UIColor(red: 0, green: 122/255, blue: 240/255, alpha: 1)
    }
}

extension ViewController {
    
    /*
    @objc func didTapAttributedTextInLabel(_ gesture: UITapGestureRecognizer) {
        
        let cell =
        
        let labelSize = textLabel.bounds.size
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: textLabel.attributedText!)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.maximumNumberOfLines = textLabel.numberOfLines
        textContainer.size = labelSize
        
        let locationOfTouchInLabel = gesture.location(in: gesture.view)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width-textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x , y: (labelSize.height - textBoundingBox.size.height)*0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        let n1 = NSRange(self.moreStringRange!, in: textLabel.text!)
        
        if NSLocationInRange(indexOfCharacter, n1) {
            print("Inside")
        }
    }*/
   
}
