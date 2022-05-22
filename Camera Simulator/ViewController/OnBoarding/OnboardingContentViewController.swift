//
//  OnboardingContentViewController.swift
//  Camera Simulator
//
//  Created by Rasyid Ridla on 13/05/22.
//

import UIKit

class OnboardingContentViewController: UIViewController {

    @IBOutlet weak var imgContent: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!
    
    var index = 0
    var heading = ""
    var subheading = ""
    var image = UIImage()
    var bgColor = UIColor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = bgColor
        imgContent.image = image
        headingLabel.text = heading
        subHeadingLabel.text = subheading
    }
}
