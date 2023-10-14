//
//  ViewController.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 10/15/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func changePartBold(part: String, fsize: CGFloat) {
        guard let text = self.myLabel.text else { return }
        let font = UIFont.systemFont(ofSize: fsize, weight: .bold)
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.font, value: 1, range: (text as NSString).range(of: part))
        self.myLabel.attributedText = attributeString
    }
}
