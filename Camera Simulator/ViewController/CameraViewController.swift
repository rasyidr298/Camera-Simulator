//
//  CameraViewController.swift
//  Camera Simulator
//
//  Created by Rasyid Ridla on 11/05/22.
//

import UIKit

class CameraViewController: UIViewController {
    
    @IBOutlet weak var imgCamera: UIImageView!
    private var listImage = [UIImage(named: "bg_test1"), UIImage(named: "bg_test2")]
    private var indexImage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgCamera.image = listImage[indexImage]
    }
    
    @IBAction func btnNext(_ sender: Any) {
        if indexImage == listImage.count-1 {
            indexImage = 0
        }else {
            indexImage += 1
        }
        
        //animate right
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options:.transitionFlipFromRight,
            animations: {
                self.imgCamera.image = self.listImage[self.indexImage]
                self.imgCamera?.frame.origin.x = 600
        })
    }
    
    @IBAction func btnPrevious(_ sender: Any) {
        if indexImage == 0 {
            indexImage = listImage.count-1
        }else {
            indexImage -= 1
        }
        
        //animate left
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options:.transitionFlipFromLeft,
            animations: {
                self.imgCamera.image = self.listImage[self.indexImage]
                self.imgCamera?.frame.origin.x = -600
        })
    }
    
}
