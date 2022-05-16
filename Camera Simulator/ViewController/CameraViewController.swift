//
//  CameraViewController.swift
//  Camera Simulator
//
//  Created by Rasyid Ridla on 11/05/22.
//

import UIKit

class CameraViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var objectImage: UIImageView!
    
    private var listBackgroundImage = [UIImage(named: "bg_test1"), UIImage(named: "bg_test2")]
    private var listObjectImage = [UIImage(named: "bg_test2"), UIImage(named: "bg_test1")]
    private var indexImage = 0
    var transition = CATransition()
    var context = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateImageView(type: "next")
        blurEffect(uiImage: backgroundImage, value: 5)
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
        
        backgroundImage.layer.add(transition, forKey: kCATransition)
        objectImage.layer.add(transition, forKey: kCATransition)
        
        if listBackgroundImage.count != 0 {
            backgroundImage.image = listBackgroundImage[indexImage]
            objectImage.image = listObjectImage[indexImage]
        }
        CATransaction.commit()
        indexImage = indexImage < listBackgroundImage.count - 1 ? indexImage + 1 : 0
    }

    func blurEffect(uiImage: UIImageView, value: Int) {
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: uiImage.image!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(value, forKey: kCIInputRadiusKey)

        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")

        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        uiImage.image = processedImage
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
