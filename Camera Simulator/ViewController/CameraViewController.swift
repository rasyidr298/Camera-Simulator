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
    var transition = CATransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

extension CameraViewController {
    
    func animateImageView(type: String) {
        
        switch type {
            case "next" :
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
            case "previous" :
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromLeft
            default:
                    transition.type = CATransitionType.push
                    transition.subtype = CATransitionSubtype.fromRight
        }
        
        imgCamera.layer.add(transition, forKey: kCATransition)
        if listImage.count != 0 {
            imgCamera.image = listImage[indexImage]
        }
        CATransaction.commit()
        indexImage = indexImage < listImage.count - 1 ? indexImage + 1 : 0
    }
}

extension CameraViewController {
    
    @IBAction func btnNext(_ sender: Any) {
        animateImageView(type: "next")
    }
    
    @IBAction func btnPrevious(_ sender: Any) {
        animateImageView(type: "previous")
    }
    
    @IBAction func btnLearning(_ sender: Any) {
            let destinationVC = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: learningVcId) as! LearningViewController
            navigationController?.pushViewController(destinationVC, animated: true)
    }
}
