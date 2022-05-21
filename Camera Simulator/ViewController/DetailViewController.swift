//
//  DetailViewController.swift
//  Camera Simulator
//
//  Created by Rasyid Ridla on 15/05/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var learningImage: UIImageView!
    var learning: Learning?

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var keterangan: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        label.text = learning?.learningTitle
        keterangan.text = learning?.learningDesc
        
        
    }
    
    
    func setupView() {
        let jeremyGif = UIImage.gifImageWithName(learning!.learningAnim)
        learningImage.image = jeremyGif
    }
    
    override func viewWillLayoutSubviews() {
           keterangan.sizeToFit()
       }
        
    
    
   
    
    
}

