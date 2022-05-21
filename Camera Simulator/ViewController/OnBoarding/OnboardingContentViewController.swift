//
//  OnboardingContentViewController.swift
//  Camera Simulator
//
//  Created by Rasyid Ridla on 13/05/22.
//

import UIKit

class OnboardingContentViewController: UIViewController {

    @IBOutlet weak var imgContent: UIImageView!
    @IBOutlet weak var contentLabel: UILabel! {
        didSet {
            contentLabel.numberOfLines = 0
        }
    }
    
    var index = 0
    var heading = ""
    var subheading = ""
    var image = UIImage()
    var bgColor = UIColor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextLabel()
        imgContent.image = image
//        view.backgroundColor = bgColor
    }
    
    func setupTextLabel() {
        let atributedText = NSMutableAttributedString(string: heading, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        atributedText.append(NSAttributedString(string: "\n\n\(subheading)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white]))
        
        contentLabel.attributedText = atributedText
        contentLabel.textAlignment = .center
        
    }
}
