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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let showOnboarding = UserDefaults.standard.bool(forKey: showOnBoard)
        if !showOnboarding {
            let onBoardingVC = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: onBoardVCId) as! OnBoardingViewController
            
            onBoardingVC.modalPresentationStyle = .overCurrentContext
            present(onBoardingVC, animated: true)
        }
    }
    
    @IBAction func btnNext(_ sender: Any) {
        if indexImage == listImage.count-1 {
            indexImage = 0
        }else {
            indexImage += 1
        }
        
        self.imgCamera.image = self.listImage[self.indexImage]
        
        //animate right
//        UIView.animate(
//            withDuration: 0.5,
//            delay: 0.0,
//            options:.transitionFlipFromRight,
//            animations: {
//                self.imgCamera.image = self.listImage[self.indexImage]
//                self.imgCamera?.frame.origin.x = 600
//        })
    }
    
    @IBAction func btnPrevious(_ sender: Any) {
        if indexImage == 0 {
            indexImage = listImage.count-1
        }else {
            indexImage -= 1
        }
        
        self.imgCamera.image = self.listImage[self.indexImage]
        
        //animate left
//        UIView.animate(
//            withDuration: 0.5,
//            delay: 0.0,
//            options:.transitionFlipFromLeft,
//            animations: {
//                self.imgCamera?.frame.origin.x = -600
//        })
    }
    
    @IBAction func btnLearning(_ sender: Any) {
            let destinationVC = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: learningVcId) as! LearningViewController
            navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}
